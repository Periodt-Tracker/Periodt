// import {
// 	type Component,
// 	createEffect,
// 	For,
// 	on,
// 	onMount,
// 	Suspense,
// } from "solid-js";
// import { useCycle } from "@/lib/cycle/cycle-context";
// import { todayIso } from "@/lib/utilities/date";
// import { merge } from "../../utilities/class";
//
// const CycleTimeline: Component = () => {
// 	let containerRef!: HTMLDivElement;
//
// 	// TODO: make this re-active
// 	const today = todayIso();
//
// 	const context = useCycle();
//
// 	createEffect(() => {
// 		on(
// 			() => context.forcast(),
// 			() =>
// 				containerRef?.scrollIntoView({
// 					behavior: "smooth",
// 					inline: "center",
// 					block: "nearest",
// 				}),
// 		);
// 	});
//
// 	return (
// 		<div
// 			ref={containerRef}
// 			class="w-full overflow-x-scroll overflow-y-clip flex flex-row gap-4 no-scrollbar py-2 animate-in slide-in-from-bottom-15 zoom-in-95 duration-700"
// 		>
// 			<Suspense>
// 				<For each={context.forcast()}>
// 					{(day) => (
// 						<div
// 							id={`periodt__timeline-${day.date}`}
// 							data-active={today === day.date}
// 							class={merge(
// 								"bg-cycle-light shrink-0 w-12 h-16 rounded-lg flex flex-col text-center text-xl p-2 shadow-lg scroll-pl-10",
// 								"text-cycle-primary font-bold data-[active=true]:border-4 border-cycle-primary",
// 							)}
// 							style={{
// 								"--cycle-primary": `--${day.phase}-primary`,
// 								"--cycle-secondary": `--${day.phase}-secondary`,
// 								"--cycle-light": `--${day.phase}-light`,
// 							}}
// 						>
// 							<span style={{ color: `var(--${day.phase}-primary)` }}>
// 								{day.cycle_day}
// 							</span>
// 						</div>
// 					)}
// 				</For>
// 			</Suspense>
// 		</div>
// 	);
// };

import { useCycle } from "@/lib/cycle/cycle-context";
import { FaSolidCaretDown, FaSolidHeart } from "solid-icons/fa";
import { createSignal, For, onMount } from "solid-js";

const DAYS = Array.from({ length: 30 }, (_, i) => `${i + 1}`.padStart(2, "0"));

const ITEM_WIDTH = 72;

function CycleTimeline() {
	let container!: HTMLDivElement;

	const context = useCycle();

	const [offset, setOffset] = createSignal(0);
	const [startX, setStartX] = createSignal(0);
	const [startOffset, setStartOffset] = createSignal(0);
	const [selected, setSelected] = createSignal(0);

	const centerOffset = () => container.clientWidth / 2 - ITEM_WIDTH / 2;

	const clampOffset = (value: number) => {
		const min = -((DAYS.length - 1) * ITEM_WIDTH) + centerOffset();
		const max = centerOffset();
		return Math.min(max, Math.max(min, value));
	};

	const snapToIndex = (index: number) => {
		const clamped = Math.max(
			0,
			Math.min(context.forcast()?.length ?? 0 - 1, index),
		);
		setSelected(clamped);
		setOffset(-clamped * ITEM_WIDTH + centerOffset());
	};

	const onPointerDown = (e: PointerEvent) => {
		e.preventDefault();
		container.setPointerCapture(e.pointerId);
		setStartX(e.clientX);
		setStartOffset(offset());
	};

	const onPointerMove = (e: PointerEvent) => {
		if (!container.hasPointerCapture(e.pointerId)) return;
		const dx = e.clientX - startX();
		setOffset(clampOffset(startOffset() + dx));
	};

	const onPointerUp = (e: PointerEvent) => {
		container.releasePointerCapture(e.pointerId);

		const index = Math.round((-offset() + centerOffset()) / ITEM_WIDTH);

		snapToIndex(index);
	};

	onMount(() => {
		snapToIndex(0);
	});

	return (
		<div class="w-full py-6 overflow-hidden">
			<div
				ref={container}
				class="relative w-full touch-none"
				onPointerDown={onPointerDown}
				onPointerMove={onPointerMove}
				onPointerUp={onPointerUp}
			>
				<FaSolidCaretDown class="absolute left-1/2 transform -translate-x-1/2 -top-6 h-fit w-6 text-white z-10" />

				<div
					class="flex transition-transform duration-300 ease-out"
					style={{
						transform: `translateX(${offset()}px)`,
					}}
				>
					<For each={context.forcast()}>
						{(day, i) => (
							<div
								class="w-14 shrink-0 py-4 text-center transition-all bg-cycle-light rounded-2xl mx-2 shadow-lg text-xl font-semibold"
								classList={{
									"text-cycle-primary font-bold scale-110": i() === selected(),
									"text-gray-500": i() !== selected(),
								}}
							>
								{new Date(day.date).toLocaleDateString("en-us", {
									day: "2-digit",
								})}

								<div class="text-cycle-primary w-fit mx-auto mt-2">
									<FaSolidHeart />
								</div>
							</div>
						)}
					</For>
				</div>
			</div>
		</div>
	);
}

export default CycleTimeline;
