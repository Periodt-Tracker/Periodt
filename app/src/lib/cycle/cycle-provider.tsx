import {
	createEffect,
	createMemo,
	createResource,
	createSignal,
	type ParentComponent,
} from "solid-js";
import { CycleContext } from "./cycle-context";
import type { CyclePhase } from "./types";
import { simplePredictionBackend } from "./prediction/simple";
import { useSettings } from "../settings";
import type { DayEntry } from "../symptoms/types";
import * as _ from "radash";
import { todayIso } from "../utilities/date";

const PeriodProvider: ParentComponent = (props) => {
	const context = useSettings();

	const periods = [{ start_date: "2026-01-01", duration: 5 }];
	const records: DayEntry[] = [];

	const [phase, setPhase] = createSignal<CyclePhase>("period");
	const [selected_day, set_selected_day] = createSignal<string>(todayIso());

	const [forcast] = createResource(async () => {
		return await simplePredictionBackend.forcast(90, {
			settings: context.settings,
			periods,
			records,
		});
	});

	const cycles = createMemo(() => {
		const values = forcast();

		if (!values) {
			return [];
		}

		const result: {
			period: number;
			follicular: number;
			ovulation: number;
			luteal: number;
		}[] = [];

		let currentCycle = {
			period: 0,
			follicular: 0,
			ovulation: 0,
			luteal: 0,
		};

		values.forEach((day, index) => {
			if (day.phase === "period" && index !== 0) {
				result.push(currentCycle);
				currentCycle = { period: 0, follicular: 0, ovulation: 0, luteal: 0 };
			}

			currentCycle[day.phase] += 1;
		});

		// Push the last cycle
		result.push(currentCycle);

		return result;
	});

	const selectedPhase = (): CyclePhase => {
		const values = dayMap();

		if (!values) {
			return "period";
		}

		const day = selected_day();

		const value = values[day];

		if (!value) {
			return "period";
		}

		return value.phase;
	};

	const dayMap = createMemo(() => {
		const values = forcast();

		if (!values) {
			return {};
		}

		return _.objectify(
			values,
			(value) => value.date,
			(value) => ({
				cycle_day: value.cycle_day,
				phase: value.phase,
				probabilites: value.probabilites,
			}),
		);
	});

	createEffect(() => {
		const current_phase = selectedPhase();

		document.documentElement.style.setProperty(
			"--cycle-primary",
			`var(--${current_phase}-primary)`,
		);

		document.documentElement.style.setProperty(
			"--cycle-secondary",
			`var(--${current_phase}-secondary)`,
		);

		document.documentElement.style.setProperty(
			"--cycle-light",
			`var(--${current_phase}-light)`,
		);
	});

	return (
		<CycleContext.Provider
			value={{
				current_phase: selectedPhase,
				forcast,
				selected_day,
				set_selected_day,
			}}
		>
			{props.children}
		</CycleContext.Provider>
	);
};

export default PeriodProvider;
