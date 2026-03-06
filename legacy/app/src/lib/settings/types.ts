import type { SetStoreFunction, Store } from "solid-js/store";
import type { PeriodtSettings } from "./constants";

export interface SettingsContextType {
	settings: Store<PeriodtSettings>;

	setSettings: SetStoreFunction<PeriodtSettings>;
}

export type SecurityMethod = "device" | "pin" | "none";
