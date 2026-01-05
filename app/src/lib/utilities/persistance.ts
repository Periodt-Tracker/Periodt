export const makePersistedStore = <T extends object>(initial: T, key: string) => {
	const persisted = loadStorage<T>(key, initial);
	const [storeValue, setStore] = createStore(persisted);

	createEffect(() => saveStorage(key, storeValue));

	return [storeValue, setStore] as const;
};
