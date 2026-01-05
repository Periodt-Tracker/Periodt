import type { SetStoreFunction, Store } from "solid-js/store";
import type { Maybe } from "../utilities/types";

export type PeriodtSettings = {
	name: Maybe<string>;
};

export interface SettingsContextType {
	settings: Store<PeriodtSettings>;

	setSettings: SetStoreFunction<PeriodtSettings>;
}
