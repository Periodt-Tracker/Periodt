import { App } from "@capacitor/app";
import {
	type Component,
	children,
	createSignal,
	For,
	type JSX,
	Match,
	type ParentComponent,
	Switch,
} from "solid-js";
import { Dynamic } from "solid-js/web";
import { TransitionGroup } from "solid-transition-group";
import { intoArray } from "../utilities/collection";
import { NavigatorContext } from "./navigator-context";
import type { Overlay, OverlayOptions, Page } from "./types";

export interface NavigatorProps {
	intialPage: string;

	layout: ParentComponent;

	fallback?: JSX.Element;
}

export const NavigatorPage = (props: Page) => {
	return props as unknown as JSX.Element;
};

export const Navigator: ParentComponent<NavigatorProps> = (props) => {
	const pageAccessor = children(() => props.children);

	const pages = () => {
		const values = pageAccessor() as unknown as Page | Page[];

		return intoArray(values);
	};

	const [overlayStack, setOverlayStack] = createSignal<Overlay[]>([]);
	const pageHistory: string[] = [];

	const [currentPage, __setCurrentPage] = createSignal(props.intialPage);

	const overlay = (component: Component, options?: OverlayOptions) => {
		const route = { component, ...options };

		setOverlayStack((stack) => [...stack, route]);
	};

	const setPage = (page: string) => {
		const current = currentPage();

		if (page === current) {
			return;
		}

		pageHistory.push(current);
		__setCurrentPage(page);
	};

	const back = () => {
		const routes = overlayStack();

		if (routes.length > 0) {
			setOverlayStack((stack) => stack.slice(0, -1));
			return true;
		}

		const previous = pageHistory.pop();

		if (previous) {
			setPage(previous);
			return;
		}

		return true;
	};

	const reset = () => setOverlayStack([]);

	App.addListener("backButton", () => {
		const didPop = back();

		if (!didPop) {
			App.exitApp();
		}
	});

	return (
		<NavigatorContext.Provider
			value={{ overlayStack, overlay, back, reset, setPage }}
		>
			<div class="relative w-svw h-svh overflow-hidden">
				<div class="absolute inset-0">
					<Dynamic component={props.layout}>
						<Switch>
							<For each={pages()}>
								{(item) => (
									<Match when={item.name === currentPage()}>
										<Dynamic component={item.component} />
									</Match>
								)}
							</For>
						</Switch>
					</Dynamic>
				</div>

				<TransitionGroup
					name="group-item"
					enterActiveClass="animate-in slide-in-from-right"
					exitActiveClass="animate-out slide-out-to-right"
				>
					<For each={overlayStack()}>
						{(route) => (
							<div class="group-item absolute inset-0 duration-300 ease-in-out shadow-lg">
								<Dynamic component={route.component} />
							</div>
						)}
					</For>
				</TransitionGroup>
			</div>
		</NavigatorContext.Provider>
	);
};
