import { FaSolidArrowRight } from "solid-icons/fa";
import {
	type Component,
	createSignal,
	Index,
	Match,
	mergeProps,
	Switch,
} from "solid-js";
import type { SetStoreFunction, Store } from "solid-js/store";
import { Dynamic } from "solid-js/web";
import Button from "../button";
import type { StepperPageProps } from "./types";

export interface StepperProps<T extends object> {
	initialPage?: number | undefined;

	form: Store<T>;

	setForm: SetStoreFunction<T>;

	pages: Component<StepperPageProps<T>>[];

	onSubmit: (form: T) => void;
}

export const Stepper = <T extends object>(__props: StepperProps<T>) => {
	const props = mergeProps({ intialPage: 0 }, __props);

	const [page, setPage] = createSignal(0);

	const nextPage = () => {};

	const pageCount = () => props.pages.length;

	return (
		<div class="relative flex flex-col h-full">
			<Switch>
				<Index each={props.pages}>
					{(item, index) => (
						<Match when={page() === index}>
							<Dynamic
								component={item()}
								page={page()}
								setPage={setPage}
								form={props.form}
								setForm={props.setForm}
								submit={props.onSubmit}
								onValidChanged={setValid}
							/>
						</Match>
					)}
				</Index>
			</Switch>

			<Button
				class="mt-6 mb-6 w-full flex place-items-center gap-2 justify-center"
				disabled={!valid()}
				onClick={nextPage}
			>
				Continue
				<FaSolidArrowRight />
			</Button>
		</div>
	);
};
