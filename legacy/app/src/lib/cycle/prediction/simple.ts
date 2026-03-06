import type { CyclePhase, ForcastDay } from "../types";
import type { PredictionBackend, PredictionContext } from "./types";
import * as _ from "radash";
import { discreteRangeAverage } from "@/lib/utilities/range";

// a simple average based prediction forcasting model. note
// this is purely for testing and is highly inaccurate and
// should not be used in production builds
//
export const simplePredictionBackend: PredictionBackend = {
	forcast(days: number, context: PredictionContext): ForcastDay[] {
		const last_period = _.last(context.periods);
		if (!last_period) {
			return [];
		}

		// Start forecasting from the start of the last period
		const startDate = new Date(last_period.start_date);

		const cycle_range = context.settings.cycle_length;
		const average_cycle = discreteRangeAverage(cycle_range);

		const period_range = context.settings.period_length;
		const average_period = discreteRangeAverage(period_range);

		const estimatedOvulationDay = average_cycle - 14;

		// Ovulation window (±1 day)
		const ovulationStart = estimatedOvulationDay - 1;
		const ovulationEnd = estimatedOvulationDay + 1;

		return _.list(0, days).map((offset): ForcastDay => {
			const date = new Date(startDate);
			date.setDate(startDate.getDate() + offset);

			// Cycle day relative to anchor
			const absoluteDay = offset;
			const cycle_day =
				(((absoluteDay % average_cycle) + average_cycle) % average_cycle) + 1;

			let phase: CyclePhase;

			if (cycle_day <= average_period) {
				phase = "period";
			} else if (cycle_day >= ovulationStart && cycle_day <= ovulationEnd) {
				phase = "ovulation";
			} else if (cycle_day < ovulationStart) {
				phase = "follicular";
			} else {
				phase = "luteal";
			}

			return {
				date: date.toISOString().split("T")[0],
				cycle_day,
				phase,
				probabilites: {
					period: 0,
					follicular: 0,
					ovulation: 0,
					luteal: 0,
				},
			};
		});
	},
};
