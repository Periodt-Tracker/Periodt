import { createMemo, createSignal, For, type Component } from "solid-js";
import { phases } from "@/lib/period/constants";
import type { CyclePhase } from "@/lib/period/types";
import { sum } from "@/lib/utilities/collection";
import type { CycleArc } from "./types";
import blob from "@/assets/blob.svg";

const radius = 54;
const circumference = 2 * Math.PI * radius;
const gap = 16;
const width = 6;
const animationDuration = 1600;

interface CycleProps {
	day: number;

	forcast: CyclePhase[];
}

const CycleWheel: Component<CycleProps> = (props) => {
	const [cycle, setCycle] = createSignal({
		period: 5,
		follicular: 8,
		ovulation: 4,
		luteal: 10,
	});

	const forcast = createMemo(() => {
		const data = cycle();
		const arcs: CycleArc[] = [];

		const values = Object.values(data);
		const totalDays = sum(values);

		let offset = gap / 2;

		for (const phase of phases) {
			const days = data[phase];

			const portion = days / totalDays;
			const length = portion * circumference - gap / 2;

			console.log({ phase, days, totalDays, circumference, gap });

			const arc: CycleArc = {
				length,
				offset,
				colour: `var(--${phase}-primary)`,
				delay: (offset / circumference) * animationDuration - 20,
				duration: portion * animationDuration,
			};
			arcs.push(arc);

			offset += length + gap / 2;
		}

		return arcs;
	});

	return (
		<div class="relative">
			<svg id="periodt__cycle-wheel" viewBox="0 0 120 120" class="drop-shadow-xl">
				<title>Cycle Circle</title>

				<circle cx="60" cy="60" r={radius} fill="white" />
				<circle cx="60" cy="60" r={radius * 0.85} class="fill-period-light" />

				<For each={forcast()}>
					{(arc) => (
						<circle
							cx="60"
							cy="60"
							r={radius}
							fill="none"
							stroke={arc.colour}
							stroke-width={width}
							stroke-linecap="round"
							stroke-dasharray={`0 ${circumference}`}
							stroke-dashoffset={-arc.offset}
							class="hover:stroke-[8] transition-[stroke-width]"
							transform="rotate(-90 60 60)"
						>
							<animate
								attributeName="stroke-dasharray"
								begin={`${arc.delay}ms`}
								from={`0 ${circumference}`}
								to={`${arc.length} ${circumference}`}
								dur={`${arc.duration}ms`}
								fill="freeze"
							/>
						</circle>
					)}
				</For>
			</svg>

			<div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-black animate-in zoom-in-10 duration-700 text-center">
				<img class="w-36 h-36" alt="blob" src={blob} />

				<div class="flex flex-col mt-2">
					<span class="font-bold text-xl">Period</span>
					<span class="text-sm opacity-50">Day 2</span>
				</div>
			</div>
		</div>
	);
};

export default CycleWheel;
