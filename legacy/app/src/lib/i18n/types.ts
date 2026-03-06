import type * as i18n from "@solid-primitives/i18n";

import type { Accessor, Setter } from "solid-js";
import type { dict } from "./locales/en";

export interface LocaleDetails {
	key: Locale;

	flag: string;
}

export interface I18nContextType {
	locale: Accessor<Locale>;

	locale_details: Record<Locale, { flag: string }>;

	// this doesn't need to be reactive because
	// it won't change
	available_locales: LocaleDetails[];

	setLocale: Setter<Locale>;

	t: i18n.Translator<Dictionary>;
}

export type DeepPartial<T> =
	T extends Record<string, unknown>
	? { [K in keyof T]?: DeepPartial<T[K]> }
	: T;

export type RawDictionary = typeof dict;
export type Dictionary = i18n.Flatten<RawDictionary>;

export type Locale = "en" | "pl";
