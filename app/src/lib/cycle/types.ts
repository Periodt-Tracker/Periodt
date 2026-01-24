import type { Accessor, Resource, Setter } from "solid-js";
import type { phase } from "./constants";

export type CyclePhase = (typeof phase)[keyof typeof phase];

export interface Cycle {
	days: ForcastDay[];
	phases: Record<CyclePhase, number>;
}

export interface CycleContextType {
	selected_day: Accessor<string>;

	set_selected_day: Setter<string>;

	current_phase: Accessor<CyclePhase>;

	forcast: Resource<ForcastDay[] | undefined>;

	cycles: Accessor<Cycle>;
}

export interface ForcastDay {
	date: string;
	cycle_day: number;
	phase: CyclePhase;
	probabilites: Record<CyclePhase, number>;
}

export interface Period {
	start_day: Date;
	end_day: Date;
}
