import {
	createEffect,
	createMemo,
	createSignal,
	For,
	Show,
	type Component,
} from "solid-js";
import { phase, phases } from "@/lib/cycle/constants";
import type { CyclePhase } from "@/lib/cycle/types";
import { sum } from "@/lib/utilities/collection";
import type { CycleArc } from "./types";
import blob from "@/assets/blob.svg";
import { useCycle } from "@/lib/cycle/cycle-context";
import * as _ from "radash";
import { values } from "@/lib/utilities/object";
import { throttleRAF } from "@/lib/utilities/throttle";
import HelpMenu from "./help";
import { Haptics, ImpactStyle } from "@capacitor/haptics";
import { useLocale } from "@/lib/i18n";
import { Switch } from "@kobalte/core";

const radius = 54;
const circumference = 2 * Math.PI * radius;
const gap = 16;
const width = 6;
const animationDuration = 1600;
const center = 60;

const CycleWheel: Component = () => {
	let wheelRef!: SVGSVGElement;

	const [day, setDay] = createSignal(0);

	const { t } = useLocale();
	const context = useCycle();

	const cycle = createMemo<Record<CyclePhase, number> | undefined>(() => {
		const forcast = context.forcast();

		if (!forcast) {
			return undefined;
		}

		const durations = { period: 0, follicular: 0, ovulation: 0, luteal: 0 };
		let pastFirstPeriod = false;

		for (const day of forcast) {
			durations[day.phase]++;

			if (day.phase === "follicular") {
				pastFirstPeriod = true;
			} else if (day.phase === "period" && pastFirstPeriod) {
				break;
			}
		}

		return durations;
	});

	const cycleLength = () => {
		const durations = cycle();

		if (!durations) {
			return 0;
		}

		return _.sum(values(durations));
	};

	const angle = () => {
		const dayCount = cycleLength();

		if (dayCount === 0) {
			return 0;
		}

		const increment = (2 * Math.PI) / dayCount;
		const dayIndex = day();

		return (dayIndex * increment - Math.PI / 2 + 2 * Math.PI) % (2 * Math.PI);
	};

	const getDayFromPointer = (event: PointerEvent, svg: SVGSVGElement) => {
		const dayCount = cycleLength();

		if (dayCount === 0) {
			return 0;
		}

		const bounds = svg.getBoundingClientRect();

		const x = event.clientX - bounds.left - bounds.width / 2;
		const y = event.clientY - bounds.top - bounds.height / 2;

		// atan2: 0 = right, CCW positive
		let angle = Math.atan2(y, x);

		angle += Math.PI / 2;

		if (angle < 0) angle += 2 * Math.PI;

		const increment = (2 * Math.PI) / dayCount;
		return Math.floor(angle / increment);
	};

	const startDrag = (event: PointerEvent) => {
		event.preventDefault();

		if (!wheelRef) {
			return;
		}

		setDay(getDayFromPointer(event, wheelRef!));

		const handlePointerMove = throttleRAF((ev: PointerEvent) => {
			ev.preventDefault();

			const newDay = getDayFromPointer(ev, wheelRef!);

			setDay((day) => {
				if (day !== newDay) {
					Haptics.impact({ style: ImpactStyle.Light });
				}

				return newDay;
			});

			const forcast = context.forcast();

			if (!forcast) {
				return;
			}

			context.set_selected_day(forcast[newDay].date);
		});

		const handlePointerUp = () => {
			window.removeEventListener("pointermove", handlePointerMove);
			window.removeEventListener("pointerup", handlePointerUp);
		};

		window.addEventListener("pointermove", handlePointerMove);
		window.addEventListener("pointerup", handlePointerUp);
	};

	const thumbX = () => center + radius * Math.cos(angle());

	const thumbY = () => center + radius * Math.sin(angle());

	const forcast = createMemo(() => {
		const data = cycle();

		if (!data) {
			return;
		}

		const arcs: CycleArc[] = [];

		const values = Object.values(data);
		const totalDays = sum(values);

		let offset = 0;

		for (const phase of phases) {
			const days = data[phase];

			const portion = days / totalDays;
			const length = portion * circumference - gap / 2;

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
					<span class="font-bold text-xl">
						{t(`home.phase.${context.current_phase()}`)}
					</span>
					<span class="text-sm opacity-50">
						<Show
							when={context.current_phase() === phase.period}
							fallback={t("home.period_in", cycleLength() - day())}
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
