import type { ParentComponent } from "solid-js";
import { preferencesPersistance } from "../persistance/preferences";
import { makePersistedStore } from "../persistance/store";
import { SettingsContext } from "./settings-context";
import type { PeriodtSettings, SettingsContextType } from "./types";

const SettingsProvider: ParentComponent = (props) => {
	const [settings, setSettings] = makePersistedStore<PeriodtSettings>(
		"settings",
		{ name: "Charlie" },
		{ storage: preferencesPersistance },
	);

	const context: SettingsContextType = { settings, setSettings };

	return <SettingsContext.Provider value={context}>{props.children}</SettingsContext.Provider>;
};

export default SettingsProvider;
