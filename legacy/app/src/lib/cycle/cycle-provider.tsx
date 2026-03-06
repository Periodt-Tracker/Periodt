import * as _ from "radash";
import {
	createEffect,
	createMemo,
	createResource,
	createSignal,
	type ParentComponent,
} from "solid-js";
import { useSettings } from "../settings";
import type { DayEntry } from "../symptoms/types";
import { todayIso } from "../utilities/date";
import { CycleContext } from "./cycle-context";
import { simplePredictionBackend } from "./prediction/simple";
import { computeCycles, computeDayMap } from "./utilities";

const PeriodProvider: ParentComponent = (props) => {
	const context = useSettings();

	const periods = [{ start_date: "2026-01-01", duration: 5 }];
	const records: DayEntry[] = [];

	const [selected_day, set_selected_day] = createSignal<string>(todayIso());

	const [forcast] = createResource(async () => {
		const settings = context.settings;

		return await simplePredictionBackend.forcast(90, {
			settings,
			periods,
			records,
		});
	});

	const cycles = createMemo(() => {
		const values = forcast();

		if (!values) {
			return [];
		}

		return computeCycles(values);
	});

	const dayMap = createMemo(() => {
		const values = forcast();

		if (!values) {
			return {};
		}

		return computeDayMap(values);
	});

	const selectedDay = () => {
		const map = dayMap();
		const day = selected_day();

		const value = map[day];

		if (!value) {
			return null;
		}

		return value;
	};

	const currentCycle = () => {
		const values = cycles();
	};

	createEffect(() => {
		// const current_phase = selectedDay()?.phase;
		const current_phase = "period";

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
				current_phase: () => "period",
				forcast,
				selected_day,
				set_selected_day,
				cycles,
			}}
		>
			{props.children}
		</CycleContext.Provider>
	);
};

export default PeriodProvider;
