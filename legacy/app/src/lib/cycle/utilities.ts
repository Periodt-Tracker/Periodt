import * as _ from "radash";
import type { Cycle, ForcastDay } from "./types";

// group an array of forecast days into an array of
// cycles. we always take a cycle to begin at the start
// of period.
//
export function computeCycles(forecast: ForcastDay[]): Cycle[] {
	if (forecast.length === 0) return [];

	const cycles: Cycle[] = [];
	let currentCycle: ForcastDay[] = [];

	for (let i = 0; i < forecast.length; i++) {
		const day = forecast[i];

		// If cycle_day is 1 and we already have a cycle in progress, start a new cycle
		if (day.cycle_day === 1 && currentCycle.length > 0) {
			// finalize the current cycle
			const phase_durations = countPhases(currentCycle);
			const start_date = currentCycle[0].date;
			const end_date = currentCycle[currentCycle.length - 1].date;

			cycles.push({
				days: currentCycle,
				phase_durations,
				start_date,
				end_date,
			});

			// start a new cycle
			currentCycle = [];
		}

		currentCycle.push(day);
	}

	// Push the last cycle if any
	if (currentCycle.length > 0) {
		const phase_durations = countPhases(currentCycle);
		const start_date = currentCycle[0].date;
		const end_date = currentCycle[currentCycle.length - 1].date;

		cycles.push({ days: currentCycle, phase_durations, start_date, end_date });
	}

	return cycles;
}

// Helper to count phases in a cycle
function countPhases(days: ForcastDay[]) {
	const phase_durations: Record<string, number> = {
		period: 0,
		follicular: 0,
		ovulation: 0,
		luteal: 0,
	};

	for (const day of days) {
		if (day.phase in phase_durations) {
			phase_durations[day.phase]++;
		}
	}

	return phase_durations;
}

export function computeDayMap(forcast: ForcastDay[]) {
	return _.objectify(forcast, (day) => day.date);
}
