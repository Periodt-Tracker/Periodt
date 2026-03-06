import { createContext, useContext } from "solid-js";
import type { I18nContextType } from "./types";

export const I18nContext = createContext<I18nContextType>();

export function useLocale() {
	const context = useContext(I18nContext);

	if (context === undefined) {
		throw new Error(
			"[perdiot.]: `useLocale` must be used within a `I18nContextProivder`",
		);
	}

	return context;
}
