import { createContext, useContext } from "solid-js";
import type { CycleContextType } from "./types";

export const CycleContext = createContext<CycleContextType>();

export function useCycle() {
	const context = useContext(CycleContext);

	if (context === undefined) {
		throw new Error(
			"[periodt]: `useCycle` must be used within a `CycleContext`",
		);
	}

	return context;
}
