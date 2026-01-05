import type z from "zod";
import type { MaybePromise } from "../utilities/types";

export interface PersistanceBackend {
	set(key: string, value: unknown): MaybePromise<void>;

	get<T>(key: string): MaybePromise<T | null>;

	getValidated<T extends z.ZodSchema>(
		key: string,
		schema: T,
	): MaybePromise<z.ZodSafeParseResult<z.infer<T>> | null>;

	delete(key: string): MaybePromise<void>;

	clear(): MaybePromise<void>;
}
