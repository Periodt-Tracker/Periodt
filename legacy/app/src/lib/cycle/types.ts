import type { Accessor, Resource, Setter } from "solid-js";
import type { phase } from "./constants";

export type CyclePhase = (typeof phase)[keyof typeof phase];

export type Cycle = Readonly<{
	days: ForcastDay[];
	phase_durations: Record<CyclePhase, number>;
	start_date: string;
	end_date: string;
}>;

export interface CycleContextType {
	forcast: Resource<ForcastDay[] | undefined>;

	selected_day: Accessor<string>;

	set_selected_day: Setter<string>;

	current_phase: Accessor<CyclePhase>;

	selected_day_phase: Accessor<CyclePhase>;

	cycles: Accessor<Cycle[]>;

	current_cycle: Accessor<Cycle>;
}

export interface ForcastDay {
	date: string;
	cycle_day: number;
	phase: CyclePhase;
	probabilites: Record<CyclePhase, number>;
	hormones: Record<CyclePhase, number>;
}

export interface Period {
	start_day: Date;
	end_day: Date;
}

export interface Insight {
	text: string;
}

export interface News {
	title: string;
	image?: string;
	description: string;
	link?: string;
}
