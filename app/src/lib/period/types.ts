import type { phase } from "./constants";

export type CyclePhase = (typeof phase)[keyof typeof phase];

export interface CycleContextType {
	phase: CyclePhase;
}
