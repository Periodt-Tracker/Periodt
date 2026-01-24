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
import type { SettingsContextType } from "./types";
import {
	default_settings,
	PeriodtSettingsSchema,
	type PeriodtSettings,
} from "./constants";

const SettingsProvider: ParentComponent = (props) => {
	const [loaded, setLoaded] = createSignal(false);
	const [settings, setSettings] =
		createStore<PeriodtSettings>(default_settings);

	onMount(async () => {
		const stored = await preferences.getValidated(
			"settings",
			PeriodtSettingsSchema,
		);

		if (stored?.success) {
			setSettings(stored.data);
		} else if (stored?.error) {
			console.log(stored.error);
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
