import {
	createEffect,
	createSignal,
	onCleanup,
	type Component,
} from "solid-js";
import { useSettings } from "../lib/settings";
import {
	FaSolidBars,
	FaSolidCalendar,
	FaSolidGear,
	FaSolidHouse,
} from "solid-icons/fa";
import SymptomDrawer from "@/lib/components/symptoms";
import { useNavigator } from "@/lib/navigation/navigator-context";
import Button from "@/lib/components/button";
import CycleWrapper from "@/lib/components/cycle/wrapper";
import CurrentPhase from "@/lib/components/current-phase";
import NewsView from "@/lib/components/news";
import { news_entries } from "@/lib/cycle/news";
import SettingsPage from "./settings";

const HomePage: Component = () => {
	const app = useSettings();

	const [container, setContainer] = createSignal<HTMLDivElement>();
	const [scrollY, setScrollY] = createSignal(0);

	const onScroll = () => setScrollY(container()?.scrollTop ?? 0);

	createEffect(() => {
		const element = container();

		if (!element) {
			return;
		}

		element.addEventListener("scroll", onScroll);
		onCleanup(() => element.removeEventListener("scroll", onScroll));
	});

	const navigator = useNavigator();

	const controlY = () => {
		const initialY = 0;
		const finalY = 15;

		return initialY + (finalY - initialY) * (scrollY() / 200);
	};

	return (
		<main
			id="periodt__homepage"
			ref={setContainer}
			class="bg-white h-svh overflow-scroll no-scrollbar"
		>
			<div
				id="periodt__period-status"
				class="w-svw min-h-[70svh] bg-cycle-secondary transition-colors duration-700 relative flex flex-col pt-4"
			>
				<section class="pt-8 flex flex-col gap-6">
					<section class="flex flex-row justify-between text-white place-items-center px-8">
						<div class="text-4xl">
							Hello <span class="font-semibold">{app.settings.name}!</span>
						</div>

						<button
							onClick={() => navigator.overlay(SettingsPage)}
							type="button"
							class="active:scale-90 active:bg-[#fff4] p-2 rounded-full transition-all"
						>
							<FaSolidBars size={32} />
						</button>
					</section>

					<CycleWrapper />
				</section>

				<svg viewBox="0 0 600 75" class="w-full mt-auto">
					<path
						d={`M0,75 C200,${controlY()} 400,${controlY()} 600,75`}
						fill="white"
					/>
				</svg>
			</div>

			<p class="text-black mt-8 p-8 flex flex-col gap-16 mb-18">
				<NewsView news={news_entries[0]} />

				<CurrentPhase />
			</p>
		</main>
	);
};

export default HomePage;
