import {
	type Component,
	createSignal,
	For,
	type JSX,
	type ParentComponent,
} from "solid-js";
import { Transition, TransitionGroup } from "solid-transition-group";
import { NavigatorContext } from "./navigator-context";
import { Dynamic } from "solid-js/web";
import { App } from "@capacitor/app";

export interface Route {
	component: Component;
	tranition?: string;
}

export interface NavigatorProps {
	root: Component;
	routes: Record<string, { component: Component; transition?: string }>;
}

export const Navigator: ParentComponent<NavigatorProps> = (props) => {
	const [stack, setStack] = createSignal<Route[]>([]);

	const push = (page: string) => {
		const route = props.routes[page];

		if (!route) {
			return;
		}

		setStack((stack) => [...stack, route]);
	};

	const pop = () => {
		const routes = stack();

		if (routes.length <= 0) {
			return false;
		}

		setStack((stack) => stack.slice(0, -1));
		return true;
	};

	const reset = () => setStack([]);

	App.addListener("backButton", () => {
		const didPop = pop();

		if (!didPop) {
			App.exitApp();
		}
	});

	return (
		<NavigatorContext.Provider value={{ stack, push, pop, reset }}>
			<div class="relative w-svw h-svh overflow-hidden">
				<div class="absolute inset-0">
					<Dynamic component={props.root} />
				</div>

				<TransitionGroup
					name="group-item"
					enterActiveClass="animate-in slide-in-from-right"
					exitActiveClass="animate-out slide-out-to-right"
				>
					<For each={stack()}>
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
