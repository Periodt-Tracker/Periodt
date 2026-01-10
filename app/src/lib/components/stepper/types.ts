import type { Accessor } from "solid-js";
import type { SetStoreFunction, Store } from "solid-js/store";

export interface StepperContextType<T> {
  form: T | Store<T>;
  setForm: SetStoreFunction<T>;
  nextPage: VoidFunction;
  previousPage: VoidFunction;
  page: Accessor<number>;
  pageCount: Accessor<number>;
}
