import type { Accessor } from "solid-js";

export interface StepperContextType {
  nextPage: VoidFunction;

  previousPage: VoidFunction;

  page: Accessor<number>;

  pageCount: Accessor<number>;
}
