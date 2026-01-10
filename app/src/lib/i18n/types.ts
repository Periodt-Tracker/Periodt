import type * as i18n from "@solid-primitives/i18n";

import type { Accessor, Setter } from "solid-js";
import type en_dict from "./locales/en";

export interface I18nContextType {
	locale: Accessor<Locale>;

	setLocale: Setter<Locale>;

	t: i18n.Translator<Dictionary>;
}

export type DeepPartial<T> =
	T extends Record<string, unknown>
		? { [K in keyof T]?: DeepPartial<T[K]> }
		: T;

export type RawDictionary = typeof en_dict;
export type Dictionary = i18n.Flatten<RawDictionary>;

export type Locale = "en";
