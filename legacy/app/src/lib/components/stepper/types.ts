import type { Accessor, Component, Setter } from "solid-js";
import type { SetStoreFunction, Store } from "solid-js/store";

export interface StepperPageProps<T> {
	form: Store<T>;

	page: number;

	setPage: Setter<number>;

	submit: (form: T) => void;

	setForm: SetStoreFunction<T>;

	onValidChanged: (valid: boolean) => void;
}

export type StepperPageComponent<T> = Component<StepperPageProps<T>>;

export interface StepperContextType<T> {
	form: T | Store<T>;
	setForm: SetStoreFunction<T>;
	nextPage: VoidFunction;
	previousPage: VoidFunction;
	setPage: Setter<number>;
	page: Accessor<number>;
	pageCount: Accessor<number>;
}
