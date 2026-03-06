import { FaSolidCaretDown, FaSolidHeart } from "solid-icons/fa";
import { type Component, createSignal, For, onMount } from "solid-js";
import type { Cycle } from "@/lib/cycle/types";
import type { TweenedSignal } from "@/lib/utilities/tween";

const ITEM_WIDTH = 72;
const DRAG_THRESHOLD = 5;
const BREAK_FACTOR = 4;
const MOMENTUM_MULTIPLIER = 180;

export interface CycleTimelineProps {
	cycle: Cycle;
	progress: TweenedSignal;
}

const CycleTimeline: Component<CycleTimelineProps> = (props) => {
	let container!: HTMLDivElement;

	let dragActive = false;
	let dragJustStarted = false;
	let startX = 0;
	let lastX = 0;
	let lastTime = 0;
	let velocity = 0;
	let sumDistance = 0;
	let isProperDrag = false;
	let lastAxisX: number | undefined;
	let lastAxisY: number | undefined;

	const [dragging, setDragging] = createSignal(false);
	const [selected, setSelected] = createSignal(0);

	const cycleLength = () => props.cycle.days.length;
	const centerOffset = () => container.clientWidth / 2 - ITEM_WIDTH / 2;

	const minOffset = () => -((cycleLength() - 1) * ITEM_WIDTH);
	const maxOffset = () => centerOffset();

	const offset = () => -props.progress.immediate() * ITEM_WIDTH;

	/* ---------------- keen-style helpers ---------------- */

	const clamp = (v: number, min: number, max: number) =>
		Math.min(max, Math.max(min, v));

	const sign = (v: number) => (v < 0 ? -1 : 1);

	const isSlide = (x: number, y: number) => {
		if (lastAxisX === undefined || lastAxisY === undefined) {
			lastAxisX = x;
			lastAxisY = y;
			return true;
		}
		const dx = Math.abs(lastAxisX - x);
		const dy = Math.abs(lastAxisY - y);
		lastAxisX = x;
		lastAxisY = y;
		return dx >= dy;
	};

	const rubberband = (distance: number, position: number) => {
		const min = minOffset();
		const max = maxOffset();

		if (position >= min && position <= max) return distance;

		const overflow = position < min ? position - min : position - max;

		const trackSize = ITEM_WIDTH * cycleLength();
		const windowSize = container.clientWidth;

		const overflowedSize = Math.abs(overflow);
		const p = Math.max(0, 1 - (overflowedSize / windowSize) * BREAK_FACTOR);

		return p * p * distance;
	};

	/* ---------------- snapping ---------------- */

	const snapToIndex = (index: number) => {
		const clamped = clamp(index, 0, cycleLength() - 1);
		setSelected(clamped);
		props.progress.setTweened(clamped);
	};

	/* ---------------- pointer handlers ---------------- */

	const onPointerDown = (e: PointerEvent) => {
		container.setPointerCapture(e.pointerId);

		dragActive = true;
		dragJustStarted = true;
		isProperDrag = false;
		sumDistance = 0;

		startX = e.clientX;
		lastX = e.clientX;
		lastTime = performance.now();
		velocity = 0;

		lastAxisX = undefined;
		lastAxisY = undefined;

		setDragging(true);
	};

	const onPointerMove = (e: PointerEvent) => {
		if (!dragActive) return;

		if (dragJustStarted) {
			if (!isSlide(e.clientX, e.clientY)) {
				onPointerUp(e);
				return;
			}
			dragJustStarted = false;
		}

		const now = performance.now();
		const dx = e.clientX - lastX;
		const dt = now - lastTime;

		if (dt > 0) {
			velocity = dx / dt;
			lastTime = now;
		}

		sumDistance += dx;
		if (!isProperDrag && Math.abs(sumDistance) > DRAG_THRESHOLD) {
			isProperDrag = true;
		}

		const position = offset();

		const distance = dx;
		const direction = sign(distance);
		const adjusted = rubberband(Math.abs(distance), position) * direction;

		const nextOffset = position + adjusted;
		props.progress.setImmediate(-nextOffset / ITEM_WIDTH);

		lastX = e.clientX;
	};

	const onPointerUp = (e: PointerEvent) => {
		if (!dragActive) return;

		container.releasePointerCapture(e.pointerId);
		dragActive = false;
		setDragging(false);

		const momentum = velocity * MOMENTUM_MULTIPLIER;
		const projected = clamp(offset() + momentum, minOffset(), maxOffset());

		const index = Math.round(-projected / ITEM_WIDTH);
		snapToIndex(index);
	};

	onMount(() => {
		snapToIndex(0);
	});

	/* ---------------- render ---------------- */

	return (
		<div class="w-full py-6 overflow-hidden">
			<div
				ref={container}
				class="relative w-full touch-none"
				onPointerDown={onPointerDown}
				onPointerMove={onPointerMove}
				onPointerUp={onPointerUp}
			>
				<FaSolidCaretDown class="absolute left-1/2 -translate-x-1/2 -top-6 w-6 text-white" />

				<div
					class="flex"
					classList={{
						"duration-300 ease-out": !dragging(),
					}}
					style={{
						transform: `translateX(${offset() + centerOffset()}px)`,
					}}
				>
					<For each={props.cycle.days}>
						{(day, i) => (
							<div
								class="w-14 shrink-0 py-4 mx-2 text-center rounded-2xl shadow-lg text-xl font-semibold bg-cycle-light transition-all"
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
};

export default CycleTimeline;
