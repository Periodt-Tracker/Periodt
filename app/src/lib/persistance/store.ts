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
	const [store, setStore] = createStore(initialValue, { name: options?.name });

	createEffect(async () => await storage.set(key, store));

	return [store, setStore] as const;
}
