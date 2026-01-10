import {
	createEffect,
	createSignal,
	onMount,
	type ParentComponent,
	Show,
} from "solid-js";
import { createStore } from "solid-js/store";
import SetupPage from "@/routes/setup";
import { preferences } from "../persistance/preferences";
import { SettingsContext } from "./settings-context";
import type { PeriodtSettings, SettingsContextType } from "./types";

const SettingsProvider: ParentComponent = (props) => {
	const [loaded, setLoaded] = createSignal(false);
	const [settings, setSettings] = createStore<PeriodtSettings>({
		setup_complete: false,
		name: "",
		period_length: { lower: 4, upper: 6 },
		cycle_length: { lower: 26, upper: 28 },
	});

	onMount(async () => {
		const stored = await preferences.get<PeriodtSettings>("settings");

		if (stored) {
			setSettings(stored);
		}

		setLoaded(true);
	});

	createEffect(async () => {
		if (!settings.setup_complete) {
			return;
		}

		await preferences.set("settings", settings);
	});

	const context: SettingsContextType = { settings, setSettings };

	return (
		<SettingsContext.Provider value={context}>
			<Show when={loaded()} fallback={<div>Loading</div>}>
				<Show when={settings.setup_complete} fallback={<SetupPage />}>
					{props.children}
				</Show>
			</Show>
		</SettingsContext.Provider>
	);
};

export default SettingsProvider;
