import { phases } from "../period/constants";
import type { CyclePhase } from "../period/types";

export function* iterateCycle<T extends Record<CyclePhase, U>, U>(object: T): Generator<U> {
	for (const key of phases) {
		if (object[key]) {
			yield object[key];
		}
	}
}
