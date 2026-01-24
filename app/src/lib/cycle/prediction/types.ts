import type { DayEntry } from "@/lib/symptoms/types";
import type { MaybePromise } from "@/lib/utilities/types";
import type { ForcastDay } from "../types";
import type { PeriodtSettings } from "@/lib/settings";

export interface Period {
	start_date: string; // ISO-8601 string
	duration: number;
}

export interface PredictionContext {
	settings: PeriodtSettings;
	periods: Period[];
	records: DayEntry[];
}

export interface PredictionBackend {
	forcast(days: number, context: PredictionContext): MaybePromise<ForcastDay[]>;
}
