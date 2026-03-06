import { type Component, createMemo, For, type Setter, Show } from "solid-js";
import blob from "@/assets/blob.svg";
import { phase, phases } from "@/lib/cycle/constants";
import type { Cycle } from "@/lib/cycle/types";
import { useLocale } from "@/lib/i18n";
import { throttleRAF } from "@/lib/utilities/throttle";
import {
	animationDuration,
	center,
	circumference,
	gap,
	radius,
} from "./constants";
import HelpMenu from "./help";
import type { CycleArcType } from "./types";
import CycleArc from "./wheel-arc";
import type { TweenedSignal } from "@/lib/utilities/tween";

export interface CycleTimelineProps {
	cycle: Cycle;
	progress: TweenedSignal;
}

const CycleWheel: Component<CycleTimelineProps> = (props) => {
	let wheelRef!: SVGSVGElement;

	const { t } = useLocale();

	const angle = () => {
		const dayCount = props.cycle.days.length;

		const increment = (2 * Math.PI) / dayCount;
		const dayIndex = props.progress.tweened();

		return (dayIndex * increment - Math.PI / 2 + 2 * Math.PI) % (2 * Math.PI);
	};

	const day = () => Math.round(props.progress.immediate());

	const getDayFromPointer = (
		event: PointerEvent,
		svg: SVGSVGElement,
		snap = true,
	) => {
		const dayCount = props.cycle.days.length;

		if (dayCount === 0) {
			return 0;
		}

		const bounds = svg.getBoundingClientRect();

		const x = event.clientX - bounds.left - bounds.width / 2;
		const y = event.clientY - bounds.top - bounds.height / 2;

		let angle = Math.atan2(y, x) + Math.PI / 2;

		if (angle < 0) {
			angle += 2 * Math.PI;
		}

		const increment = (2 * Math.PI) / dayCount;
		let progress = angle / increment;

		if (snap) {
			progress = Math.round(progress);
		}

		props.progress.setImmediate(progress);
	};

	const startDrag = (event: PointerEvent) => {
		event.preventDefault();

		if (!wheelRef) {
			return;
		}

		getDayFromPointer(event, wheelRef!);

		const handlePointerMove = throttleRAF((ev: PointerEvent) => {
			ev.preventDefault();

			getDayFromPointer(ev, wheelRef!, false);
		});

		const handlePointerUp = () => {
			// snap to nearest point
			props.progress.setTweened(Math.round(props.progress.immediate()));

			window.removeEventListener("pointermove", handlePointerMove);
			window.removeEventListener("pointerup", handlePointerUp);
		};

		window.addEventListener("pointermove", handlePointerMove);
		window.addEventListener("pointerup", handlePointerUp);
	};

	const thumbX = () => center + radius * Math.cos(angle());

	const thumbY = () => center + radius * Math.sin(angle());

	const forcast = createMemo(() => {
		const arcs: CycleArcType[] = [];
		const totalDays = props.cycle.days.length;

		let offset = 0;

		for (const phase of phases) {
			const days = props.cycle.phase_durations[phase];

			const portion = days / totalDays;
			const length = portion * circumference - gap / 2;

			const arc: CycleArcType = {
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
		<div class="relative touch-none select-none" onPointerDown={startDrag}>
			<svg
				id="periodt__cycle-wheel"
				ref={wheelRef}
				viewBox="0 0 120 120"
				class="drop-shadow-xl"
			>
				<title>Cycle Circle</title>

				<circle cx={center} cy={center} r={radius} fill="white" />
				<circle
					cx={center}
					cy={center}
					r={radius * 0.85}
					class="fill-cycle-light shadow-2xl"
				/>

				<For each={forcast()}>{(arc) => <CycleArc arc={arc} />}</For>

				<circle
					cx={thumbX()}
					cy={thumbY()}
					r="4"
					stroke="white"
					stroke-width="1.5"
					class="cursor-grab active:cursor-grabbing fill-[#0000] z-50 shadow-2xl"
				/>
			</svg>

			<div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-black animate-in zoom-in-10 duration-700 text-center">
				<img class="w-36 h-36" alt="blob" src={blob} />

				<div class="flex flex-col mt-2">
					<span class="font-bold text-xl">{t(`phase.${"period"}.name`)}</span>
					<span class="text-sm opacity-50">
						<Show
							when={"period" === phase.period}
							fallback={t("home.period_in", day() - 1)}
						>
							{t("home.period_day", day() + 1)}
						</Show>
					</span>
				</div>
			</div>

			<section class="absolute bottom-0 right-0 text-white">
				<HelpMenu />
			</section>
		</div>
	);
};

export default CycleWheel;
