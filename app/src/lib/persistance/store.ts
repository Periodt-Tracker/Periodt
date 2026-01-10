import { createEffect } from "solid-js";
import { createStore } from "solid-js/store";
import { preferencesPersistance } from "./preferences";
import type { PersistanceBackend } from "./types";

export interface PersistedStoreOptions {
	name?: string;

	storage?: PersistanceBackend;
}

export function makePersistedStore<T extends object>(
	key: string,
	initialValue: T,
	options: PersistedStoreOptions = {},
) {
	const storage = options?.storage ?? preferencesPersistance;
	const [store, setStore] = createStore(initialValue, {
		name: options?.name,
	});

	const initial = storage.get<T>(key);

	if (initial instanceof Promise) {
		initial.then((data) => {
			if (!data) {
				setStore(initialValue);
				return;
			}

			setStore(data);
		});
	} else if (initial) {
		setStore(initial);
	}

	createEffect(async () => await storage.set(key, store));

	return [store, setStore] as const;
}
