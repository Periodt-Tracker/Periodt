import { createContext, useContext } from "solid-js";
import type { NavigatorContextType } from "./types";

export const NavigatorContext = createContext<NavigatorContextType>();

export function useNavigator() {
	const context = useContext(NavigatorContext);

	if (context === undefined) {
		throw new Error(
			"[periodt.]: `useNaivgator` must be used within a `Navigator`",
		);
	}

	return context;
}
