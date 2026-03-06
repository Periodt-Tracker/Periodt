import type { MaybePromise } from "@/lib/utilities/types";
import type { DayEntry, LogQuery } from "../types";

export interface SymptomStorageBackend {
	fetchEntries: (query: LogQuery) => MaybePromise<DayEntry[]>;

	addEntry: (entry: DayEntry) => MaybePromise<number[]>;

	updateEntry: (updates: Partial<DayEntry>) => MaybePromise<void>;

	deleteEntry: (day: string) => MaybePromise<void>;
}
