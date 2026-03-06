import { sqlite_synchronous } from "./constants";
import { CapacitorSQLiteAdapter } from "./service";
import { migrations } from "./upgrades";

export const database = new CapacitorSQLiteAdapter({
	dbFilename: "periodt_database",
	migrations,
	sqliteOptions: {
		journalSizeLimit: 6 * 1024 * 1024,
		synchronous: sqlite_synchronous.normal,
		cacheSizeKb: 50 * 1024,
	},
});
