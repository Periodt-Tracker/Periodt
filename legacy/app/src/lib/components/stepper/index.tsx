import { Repeat } from "@solid-primitives/range";
import { FaSolidArrowRight, FaSolidChevronLeft } from "solid-icons/fa";
import {
	type Component,
	createSignal,
	For,
	Match,
	mergeProps,
	onCleanup,
	onMount,
	Show,
	Switch,
} from "solid-js";
import { createStore, type SetStoreFunction } from "solid-js/store";
import Button from "../button";
import { StepperContext } from "./stepper-context";
import { App } from "@capacitor/app";

export interface StepperPage<T extends object> {
	component: Component;
	valid: ((form: T) => boolean) | T;
}

export interface StepperProps<T extends object> {
	initialValue: T;
	initialPage?: number | undefined;
	pages: StepperPage<T>[];
	onComplete?: (form: T) => void;
}

function Stepper<T extends object>(__props: StepperProps<T>) {
	const props = mergeProps({ initialPage: 0 }, __props);

	const [form, setForm] = createStore(props.initialValue);
	const [page, setPage] = createSignal(props.initialPage);

	const pageCount = () => props.pages.length;

	const nextPage = () => {
		if (!canContinue()) {
			return;
		}

		const currentPage = page();
		const maxPage = pageCount() - 1;

		if (currentPage >= maxPage) {
			props.onComplete?.(form);
			return;
		}

		setPage(currentPage + 1);
	};

	const previousPage = () => {
		const currentPage = page();

		if (currentPage === 0) {
			return;
		}

		setPage(currentPage - 1);
	};

	const currentPage = () => {
		const index = page();

		return props.pages[index];
	};

	const canContinue = () => {
		const page = currentPage();

		if (!page) {
			return false;
		}

		if (typeof page.valid === "function") {
			return page.valid(form);
		}

		return page.valid;
	};

	onMount(() => {
		App.addListener("backButton", previousPage);
	});

	onCleanup(() => {
		App.removeAllListeners();
	});

	return (
		<StepperContext.Provider
			value={{
				nextPage,
				previousPage,
				page,
				pageCount,
				form,
				setForm: setForm as SetStoreFunction<unknown>,
				setPage,
			}}
		>
			<div class="relative flex flex-col h-full">
				<div class="grow">
					<Switch>
						<For each={props.pages}>
							{(item, index) => (
								<Match when={page() === index()}>{item.component}</Match>
							)}
						</For>
					</Switch>
				</div>

				<Button
					class="mt-6 mb-6 w-full flex place-items-center gap-2 justify-center"
					disabled={!canContinue()}
					onClick={nextPage}
				>
					Continue
					<FaSolidArrowRight />
				</Button>

				<div class="flex flex-row gap-2 m-auto place-items-center">
					<Repeat times={props.pages.length}>
						{(index) => (
							<div
								data-active={index === page()}
								class="w-3 h-3 rounded-full bg-gray-400 data-[active=true]:bg-cycle-primary data-[active=true]:w-4 data-[active=true]:h-4"
							/>
						)}
					</Repeat>
				</div>

				<Show when={page() > 0}>
					<button
						type="button"
						class="absolute bottom-0 left-2 flex flex-row gap-2 place-items-center text-sm text-muted-foreground"
						onClick={previousPage}
					>
						<FaSolidChevronLeft class="size-2" /> Back
					</button>
				</Show>
			</div>
		</StepperContext.Provider>
	);
}

export default Stepper;
