import { Capacitor } from "@capacitor/core";
import {
	CapacitorSQLite,
	type capSQLiteVersionUpgrade,
	SQLiteConnection,
	type SQLiteDBConnection,
} from "@capacitor-community/sqlite";

import { defineCustomElements } from "jeep-sqlite/loader";
import { Mutex } from "async-mutex";
import { isDev } from "solid-js/web";
import { mutexRunExclusive } from "../utilities/mutex";
import { BaseObserver } from "../utilities/observer";
import { sqlite_synchronous } from "./constants";
import type {
	CapacitorSQLiteOptions,
	DatabaseAdapter,
	DatabaseLockOptions,
	DBAdapterListener,
	LockContext,
	QueryResult,
	Transaction,
} from "./types";

export const DEFAULT_SQLITE_OPTIONS: Required<CapacitorSQLiteOptions> = {
	journalSizeLimit: 6 * 1024 * 1024,
	synchronous: sqlite_synchronous.normal,
	cacheSizeKb: 50 * 1024,
};

/**
 * Monitors the execution time of a query and logs it to the performance timeline.
 */
async function monitorQuery(
	sql: string,
	executor: () => Promise<QueryResult>,
): Promise<QueryResult> {
	if (!isDev) {
		return await executor();
	}

	const start = performance.now();
	try {
		const r = await executor();
		performance.measure(`[SQL] ${sql}`, { start });
		return r;
	} catch (e: any) {
		performance.measure(`[SQL] [ERROR: ${e.message}] ${sql}`, { start });
		throw e;
	}
}
/**
 * An implementation of {@link DBAdapter} using the Capacitor Community SQLite [plugin](https://github.com/capacitor-community/sqlite).
 *
 * @experimental
 * @alpha This is currently experimental and may change without a major version bump.
 */
export class CapacitorSQLiteAdapter
	extends BaseObserver<DBAdapterListener>
	implements DatabaseAdapter
{
	protected _writeConnection: SQLiteDBConnection | null;
	protected _readConnection: SQLiteDBConnection | null;
	protected initializedPromise: Promise<void>;
	protected writeMutex: Mutex;
	protected readMutex: Mutex;
	protected _options: {
		sqliteOptions: CapacitorSQLiteOptions;
		dbFilename: string;
		migrations: capSQLiteVersionUpgrade[];
	};

	constructor(options: {
		sqliteOptions: CapacitorSQLiteOptions;
		dbFilename: string;
		migrations: capSQLiteVersionUpgrade[];
	}) {
		super();
		console.log("initing!");
		this._options = options;
		this._writeConnection = null;
		this._readConnection = null;
		this.writeMutex = new Mutex();
		this.readMutex = new Mutex();
		this.initializedPromise = this.init();
	}

	protected get writeConnection(): SQLiteDBConnection {
		if (!this._writeConnection) {
			throw new Error("Init not completed yet");
		}
		return this._writeConnection;
	}

	protected get readConnection(): SQLiteDBConnection {
		if (!this._readConnection) {
			throw new Error("Init not completed yet");
		}
		return this._readConnection;
	}

	get name() {
		return this._options.dbFilename;
	}

	private async init() {
		const sqlite = new SQLiteConnection(CapacitorSQLite);

		const platform = Capacitor.getPlatform();

		console.log(platform);
		if (platform === "web") {
			// defineCustomElements(window);
			// Create the 'jeep-sqlite' Stencil component
			const jeepSqlite = document.createElement("jeep-sqlite");
			document.body.appendChild(jeepSqlite);
			await customElements.whenDefined("jeep-sqlite");
			// Initialize the Web store
			await sqlite.initWebStore();
		}

		// It seems like the isConnection and retrieveConnection methods
		// only check a JS side map of connections.
		// On hot reload this JS cache can be cleared, while the connection
		// still exists natively. and `createConnection` will fail if it already exists.
		await sqlite
			.closeConnection(this._options.dbFilename, false)
			.catch(() => {});
		await sqlite
			.closeConnection(this._options.dbFilename, true)
			.catch(() => {});

		sqlite.addUpgradeStatement(
			this._options.dbFilename,
			this._options.migrations,
		);

		this._writeConnection = await sqlite.createConnection(
			this._options.dbFilename,
			false,
			"no-encryption",
			1,
			false,
		);
		this._readConnection = await sqlite.createConnection(
			this._options.dbFilename,
			false,
			"no-encryption",
			1,
			true,
		);

		await this._writeConnection.open();

		const { cacheSizeKb, journalSizeLimit, synchronous } = {
			...DEFAULT_SQLITE_OPTIONS,
			...this._options.sqliteOptions,
		};

		await this.writeConnection.query("PRAGMA journal_mode = WAL");
		await this.writeConnection.query(
			`PRAGMA journal_size_limit = ${journalSizeLimit}`,
		);
		await this.writeConnection.query(`PRAGMA temp_store = memory`);
		await this.writeConnection.query(`PRAGMA synchronous = ${synchronous}`);
		await this.writeConnection.query(`PRAGMA cache_size = -${cacheSizeKb}`);

		await this._readConnection.open();
	}

	async close(): Promise<void> {
		await this.initializedPromise;
		await this.writeConnection.close();
		await this.readConnection.close();
	}

	protected generateLockContext(db: SQLiteDBConnection): LockContext {
		const _query = async (query: string, params: any[] = []) => {
			const result = await db.query(query, params);
			const arrayResult = result.values ?? [];
			return {
				rowsAffected: 0,
				rows: {
					_array: arrayResult,
					length: arrayResult.length,
					item: (idx: number) => arrayResult[idx],
				},
			};
		};

		const _execute = async (
			query: string,
			params: any[] = [],
		): Promise<QueryResult> => {
			const platform = Capacitor.getPlatform();

			if (db.getConnectionReadOnly()) {
				return _query(query, params);
			}

			if (platform === "android") {
				// Android: use query for SELECT and executeSet for mutations
				// We cannot use `run` here for both cases.
				if (query.toLowerCase().trim().startsWith("select")) {
					return _query(query, params);
				} else {
					const result = await db.executeSet(
						[{ statement: query, values: params }],
						false,
					);
					return {
						insertId: result.changes?.lastId,
						rowsAffected: result.changes?.changes ?? 0,
						rows: {
							_array: [],
							length: 0,
							item: () => null,
						},
					};
				}
			}

			// iOS (and other platforms): use run("all")
			const result = await db.run(query, params, false, "all");
			const resultSet = result.changes?.values ?? [];
			return {
				insertId: result.changes?.lastId,
				rowsAffected: result.changes?.changes ?? 0,
				rows: {
					_array: resultSet,
					length: resultSet.length,
					item: (idx) => resultSet[idx],
				},
			};
		};

		const execute = (sql: string, params?: any[]) =>
			monitorQuery(sql, () => _execute(sql, params));

		const executeQuery = (sql: string, params?: any[]) =>
			monitorQuery(sql, () => _query(sql, params));

		const getAll = async <T>(query: string, params?: any[]): Promise<T[]> => {
			const result = await executeQuery(query, params);
			return result.rows?._array ?? ([] as T[]);
		};

		const getOptional = async <T>(
			query: string,
			params?: any[],
		): Promise<T | null> => {
			const results = await getAll<T>(query, params);
			return results.length > 0 ? results[0] : null;
		};

		const get = async <T>(query: string, params?: any[]): Promise<T> => {
			const result = await getOptional<T>(query, params);
			if (!result) {
				throw new Error(`No results for query: ${query}`);
			}
			return result;
		};

		const executeRaw = async (
			query: string,
			params?: any[],
		): Promise<any[][]> => {
			// This is a workaround, we don't support multiple columns of the same name
			const results = await execute(query, params);

			return results.rows?._array.map((row) => Object.values(row)) ?? [];
		};

		return {
			getAll,
			getOptional,
			get,
			executeRaw,
			execute,
		};
	}

	execute(query: string, params?: any[]): Promise<QueryResult> {
		return this.writeLock((tx) => tx.execute(query, params));
	}

	executeRaw(query: string, params?: any[]): Promise<any[][]> {
		return this.writeLock((tx) => tx.executeRaw(query, params));
	}

	async executeBatch(
		query: string,
		params: any[][] = [],
	): Promise<QueryResult> {
		return this.writeLock(async () => {
			const result = await this.writeConnection.executeSet(
				params.map((param) => ({
					statement: query,
					values: param,
				})),
			);

			return {
				rowsAffected: result.changes?.changes ?? 0,
				insertId: result.changes?.lastId,
			};
		});
	}

	readLock<T>(
		fn: (tx: LockContext) => Promise<T>,
		options?: DatabaseLockOptions,
	): Promise<T> {
		return mutexRunExclusive(
			this.readMutex,
			async () => {
				await this.initializedPromise;
				return await fn(this.generateLockContext(this.readConnection));
			},
			options,
		);
	}

	readTransaction<T>(
		fn: (tx: Transaction) => Promise<T>,
		_?: DatabaseLockOptions,
	): Promise<T> {
		return this.readLock(async (ctx) => this.internalTransaction(ctx, fn));
	}

	writeLock<T>(
		fn: (tx: LockContext) => Promise<T>,
		options?: DatabaseLockOptions,
	): Promise<T> {
		return mutexRunExclusive(
			this.writeMutex,
			async () => {
				await this.initializedPromise;
				const result = await fn(this.generateLockContext(this.writeConnection));

				return result;
			},
			options,
		);
	}

	writeTransaction<T>(
		fn: (tx: Transaction) => Promise<T>,
		_?: DatabaseLockOptions,
	): Promise<T> {
		return this.writeLock(async (ctx) => {
			return this.internalTransaction(ctx, fn);
		});
	}

	getAll<T>(sql: string, parameters?: any[]): Promise<T[]> {
		return this.readLock((tx) => tx.getAll<T>(sql, parameters));
	}

	getOptional<T>(sql: string, parameters?: any[]): Promise<T | null> {
		return this.readLock((tx) => tx.getOptional<T>(sql, parameters));
	}

	get<T>(sql: string, parameters?: any[]): Promise<T> {
		return this.readLock((tx) => tx.get<T>(sql, parameters));
	}

	protected async internalTransaction<T>(
		context: LockContext,
		fn: (tx: Transaction) => Promise<T>,
	): Promise<T> {
		let finalized = false;
		const commit = async (): Promise<QueryResult> => {
			if (finalized) {
				return { rowsAffected: 0 };
			}
			finalized = true;
			return context.execute("COMMIT");
		};
		const rollback = async (): Promise<QueryResult> => {
			if (finalized) {
				return { rowsAffected: 0 };
			}
			finalized = true;
			return context.execute("ROLLBACK");
		};

		try {
			await context.execute("BEGIN");
			const result = await fn({
				...context,
				commit,
				rollback,
			});
			await commit();
			return result;
		} catch (ex) {
			try {
				await rollback();
			} catch (ex2) {
				// In rare cases, a rollback may fail.
				// Safe to ignore.
			}
			throw ex;
		}
	}
}
