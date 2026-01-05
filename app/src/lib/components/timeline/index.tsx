import { type Component, For } from "solid-js";
import { merge } from "../../utilities/class";

const CycleTimeline: Component = () => {
	const days = Array.from({ length: 100 }, (_, index) => index + 1);

	return (
		<div class="w-full overflow-x-scroll overflow-y-clip flex flex-row gap-4 no-scrollbar py-2">
			<For each={days}>
				{(day, index) => (
					<div
						id={`periodt__timeline-day-${day}`}
						class={merge(
							"bg-period-light shrink-0 w-12 h-16 rounded-lg flex flex-col text-center text-xl p-2 shadow-lg scroll-pl-10",
							"animate-in slide-in-from-bottom-20 duration-700 delay-100",
						)}
						style={{
							"animation-delay": `${index() * 200}ms`,
							"--tw-animation-delay": `${index() * 200}ms`,
							"transition-delay": `${index() * 200}ms`,
						}}
					>
						<span class="text-period-primary font-bold">{day}</span>
					</div>
				)}
			</For>
		</div>
	);
};

export default CycleTimeline;
