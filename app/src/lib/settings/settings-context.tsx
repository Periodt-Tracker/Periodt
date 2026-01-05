import { createContext, useContext } from "solid-js";
import type { SettingsContextType } from "./types";

export const SettingsContext = createContext<SettingsContextType>();

export function useSettings() {
	const context = useContext(SettingsContext);

	if (context === undefined) {
		throw new Error("[periodt]: `useSettings` must be used within a `SettingsProvider");
	}

	return context;
}
