import type { Accessor } from "solid-js";
import type { MaybePromise } from "../utilities/types";
import {
	conditions,
	discharge_consistency,
	discharge_odor,
	type discharge_colour,
} from "./constants";

export interface LogQuery {
	from?: string;
	to?: string;
	limit?: number;
	offset?: number;
}

export interface SymptomContextType {
	entries: Accessor<DayEntry[]>;

	fetchEntries: (query: LogQuery) => MaybePromise<DayEntry[]>;

	addEntry: (entry: DayEntry) => MaybePromise<number[]>;

	updateEntry: (updates: Partial<DayEntry>) => MaybePromise<void>;

	deleteEntry: (day: string) => MaybePromise<void>;
}

// all explicit "none" values should be encoded as such
// any nulsl will be interprerted as the value was not
// recorded by the user and discarded in predictions as
// apposed to weighted for actually being none
//
export interface DayEntry {
	bleeding: BleedingOptions | null;
	discharge: DischargeOptions | null;
	mood: MoodType[] | null;
	sex: MoodOptions[] | null;
	note: string | null;
}

export interface SexOptions {
	type: SexType;
}

export interface MoodOptions {
	type: MoodType;
}

type SexType = "protected" | "unprotected_penis" | "unprotected_other";

export type MoodType =
	| "happy"
	| "excited"
	| "neutral"
	| "irritable"
	| "angry"
	| "anxious"
	| "sad"
	| "stressed";

export interface BleedingOptions {
	level: "light" | "medium" | "heavy";
	spotting: boolean;
	clots: boolean;
	notes: string | null;
}

export type DischargeColour =
	(typeof discharge_colour)[keyof typeof discharge_colour];

export type DischargeConsistency =
	(typeof discharge_consistency)[keyof typeof discharge_consistency];

export type DischargeOdor =
	(typeof discharge_odor)[keyof typeof discharge_odor];

export interface DischargeOptions {
	colour: DischargeColour;
	consistency: DischargeConsistency | null;
	odor: DischargeOdor | null;
}

export type DischargeColourRules = Record<
	DischargeColour,
	DischargeConsistencyRules
>;

type DischargeConsistencyRules = {
	[Consistency in DischargeConsistency]?: DischargeOdorRules;
};

type DischargeOdorRules = {
	[Odor in DischargeOdor]?: { risks?: Condition[] };
};

export type Condition = (typeof conditions)[keyof typeof conditions];
