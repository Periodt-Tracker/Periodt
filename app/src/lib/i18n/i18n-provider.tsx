import * as i18n from "@solid-primitives/i18n";
import * as storage from "@solid-primitives/storage";

import * as _ from "radash";

import {
	createEffect,
	createResource,
	createSignal,
	type ParentComponent,
	Suspense,
} from "solid-js";

import en_flag from "@/assets/flags/GB-UKM.svg";
import pl_flag from "@/assets/flags/PL.svg";
import { I18nContext } from "./i18n-context";
import { dict as en_dict } from "./locales/en.ts";
import type {
	DeepPartial,
	Dictionary,
	I18nContextType,
	Locale,
	RawDictionary,
} from "./types";

const locale_details: Record<Locale, { flag: string }> = {
	en: { flag: en_flag },
	pl: { flag: pl_flag },
} as const;

const available_locales = _.listify(locale_details, (key, value) => ({
	key,
	...value,
}));

const dictionaries: Record<
	Locale,
	() => Promise<{ dict: DeepPartial<RawDictionary> }> | null
> = {
	en: () => null, // loaded by default
	pl: () => import("./locales/pl"),
};

const aliases: Record<string, Locale> = {};

const english: Dictionary = i18n.flatten(en_dict);

async function fetchDictionary(locale: Locale): Promise<Dictionary> {
	if (locale === "en") {
		return english;
	}

	const result = await dictionaries[locale]();

	if (!result) {
		return english;
	}

	const flattened = i18n.flatten(result.dict as RawDictionary);

	return { ...english, ...flattened };
}

export function intoLocale(identifier: string): Locale | undefined {
	if (identifier in dictionaries) {
		return identifier as Locale;
	}

	const alias = aliases[identifier];

	if (alias) {
		return alias;
	}

	return undefined;
}

// TODO: this is a clusterfuck, replace this
function initialLocale(): Locale {
	let locale: Locale | undefined;

	locale = intoLocale(navigator.language.slice(0, 2));

	if (locale) {
		return locale;
	}

	locale = intoLocale(navigator.language.toLocaleLowerCase());

	if (locale) {
		return locale;
	}

	return "en";
}

function deserializeLocale(value: string): Locale {
	const parsed = intoLocale(value);

	if (parsed) {
		return parsed;
	}

	return initialLocale();
}

function makeCookieOptions(): storage.CookieOptions {
	const now = new Date();

	const expires = new Date(
		now.getFullYear() + 1,
		now.getMonth(),
		now.getDate(),
	);

	return { expires };
}

const I18nProvider: ParentComponent = (props) => {
	const [locale, setLocale] = storage.makePersisted(
		createSignal<Locale>("en"),
		{
			storageOptions: makeCookieOptions(),
			storage: storage.cookieStorage,
			deserialize: (value) => deserializeLocale(value),
		},
	);

	const [dictionary] = createResource(locale, fetchDictionary, {
		initialValue: english,
	});

	createEffect(() => {
		document.documentElement.lang = locale();
	});

	const t = i18n.translator(dictionary, i18n.resolveTemplate);

	const context: I18nContextType = {
		locale_details,
		available_locales,
		t,
		locale,
		setLocale,
	};

	return (
		<Suspense>
			<I18nContext.Provider value={context}>
				{props.children}
			</I18nContext.Provider>
		</Suspense>
	);
};

export default I18nProvider;
