import type { SetStoreFunction, Store } from "solid-js/store";
import type { Maybe, NumberRange } from "../utilities/types";

export type PeriodtSettings = {
	setup_complete: boolean;
	name: string;
	securtiy: Maybe<SecurityMethod>;
	blank_screen: Maybe<boolean>;
	lock_on_resume: Maybe<boolean>;
	show_fertility: Maybe<boolean>;
	period_length: NumberRange;
	cycle_length: NumberRange;
};

export interface SettingsContextType {
	settings: Store<PeriodtSettings>;

	setSettings: SetStoreFunction<PeriodtSettings>;
}

export type SecurityMethod = "device" | "pin" | "none";
