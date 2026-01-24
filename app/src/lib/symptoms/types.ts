export interface DayEntry {
	bleeding: BleedingOptions | null;
	discharge: DischargeOptions | null;
	mood: MoodType[] | null;
	sex: SexType | null;
	note: string | null;
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
	| "bloody"
	| "clear"
	| "green"
	| "grey"
	| "white"
	| "yellow";

export type DischargeConsistency =
	| "purulent"
	| "thick"
	| "slippery"
	| "frothy"
	| "pus_like"
	| "thin"
	| "curdy"
	| "frothy";

export type DischargeOdor = "foul" | "fishy" | "mushroom";

export interface DischargeOptions {
	colour: DischargeColour;
	consistency: DischargeConsistency | null;
	odor: "DischargeOdor" | null;
}
