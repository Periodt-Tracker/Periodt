import { createContext, useContext } from "solid-js";
import type { StepperContextType } from "./types";

export const StepperContext = createContext<StepperContextType<unknown>>();

export function useStepper<T>() {
  const context = useContext(StepperContext);

  if (context === undefined) {
    throw new Error("[periodt]: `useStepper` must be used within a `StepperProvider");
  }

  return context as StepperContextType<T>;
}
