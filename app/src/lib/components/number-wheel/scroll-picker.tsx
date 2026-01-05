import {
	type ComponentProps,
	createEffect,
	createMemo,
	createSignal,
	For,
	mergeProps,
	type ParentComponent,
	splitProps,
} from "solid-js";
import { clamp } from "@/lib/utilities/number";
import type {
	WheelPickerOption,
	WheelPickerProps,
	WheelPickerValue,
} from "./types";

const RESISTANCE = 0.3; // Resistance when scrolling above the top or below the bottom
const MAX_VELOCITY = 30; // Maximum velocity for the scroll animation
const snapBackDeceleration = 10;

const easeOutCubic = (p: number) => (p - 1) ** 3 + 1;

const WheelPickerWrapper: ParentComponent<ComponentProps<"div">> = (props) => {
	const [, rest] = splitProps(props, ["children", "class"]);

	return (
		<div class={props.class} {...rest} data-rwp-wrapper>
			{props.children}
		</div>
	);
};

function WheelPicker<T extends WheelPickerValue>(__props: WheelPickerProps<T>) {
	const props = mergeProps(
		{
			infinite: false,
			visibleCount: 20,
			dragSensitivity: 3,
			scrollSensitivity: 5,
			optionItemHeight: 30,
		},
		__props,
	);

	const [value, setValue] = createSignal<T>(
		props.defaultValue ?? props.options[0]?.value,
	);

	const options = createMemo<WheelPickerOption<T>[]>(() => {
		if (!props.infinite) {
			return props.options;
		}

		const result: WheelPickerOption<T>[] = [];
		const halfCount = Math.ceil(props.visibleCount / 2);

		if (props.options.length === 0) {
			return result;
		}

		while (result.length < halfCount) {
			result.push(...props.options);
		}

		return result;
	});

	const halfItemHeight = () => props.optionItemHeight * 0.5;

	const itemAngle = () => 360 / props.visibleCount;

	const radius = () => {
		const angle = itemAngle();
		const base = Math.tan((angle * Math.PI) / 180);

		return props.optionItemHeight / base;
	};

	const containerHeight = () =>
		Math.round(radius() * 2 + props.optionItemHeight * 0.25);

	const quarterCount = () => props.visibleCount >> 2;

	const baseDeceleration = () => props.dragSensitivity * 10;

	const [containerRef, setContainerRef] = createSignal<HTMLDivElement>();
	const [wheelItemsRef, setWheelItemsRef] = createSignal<HTMLUListElement>();
	const [highlightListRef, setHighlightListRef] =
		createSignal<HTMLUListElement>();

	let scrollId = 0;
	let moveId = 0;
	let dragging = false;
	let lastWheelTime = 0;

	let touchData: {
		startY: number;
		yList: [number, number][];
		touchScroll?: number;
		isClick?: boolean;
	} = {
		startY: 0,
		yList: [],
		touchScroll: 0,
		isClick: true,
	};

	let dragController: AbortController | null = null;

	const wheelItems = createMemo(() => {
		const values = options();
		const result = [];

		values.forEach((option, index) => {
			result.push({
				item: option,
				index,
				angle: -itemAngle() * index,
			});
		});

		if (props.infinite) {
			for (let i = 0; i < quarterCount(); ++i) {
				const prependIndex = -i - 1;
				const appendIndex = i + values.length;

				result.unshift({
					item: values[values.length - i - 1],
					index: prependIndex,
					angle: itemAngle() * (i + 1),
				});

				result.push({
					item: values[i],
					index: appendIndex,
					angle: -itemAngle() * appendIndex,
				});
			}
		}

		return result;
	});

	const highlightItems = createMemo(() => {
		const values = options();

		const result = values.map((item) => ({ item }));

		if (props.infinite && values.length > 0) {
			result.unshift({ item: values[values.length - 1] });
			result.push({ item: values[0] });
		}

		return result;
	});

	const wheelSegmentPositions = createMemo(() => {
		let positionAlongWheel = 0;
		const degToRad = Math.PI / 180;

		const segmentRanges: [number, number][] = [];

		for (let i = quarterCount() - 1; i >= -quarterCount() + 1; --i) {
			const angle = i * itemAngle();
			const segmentLength = props.optionItemHeight * Math.cos(angle * degToRad);
			const start = positionAlongWheel;
			positionAlongWheel += segmentLength;
			segmentRanges.push([start, positionAlongWheel]);
		}

		return segmentRanges;
	});

	const normalizeScroll = (scroll: number) => {
		const count = options().length;

		return ((scroll % count) + count) % count;
	};

	const scrollTo = (scroll: number) => {
		const normalizedScroll = props.infinite ? normalizeScroll(scroll) : scroll;
		const wheelItems = wheelItemsRef();

		if (wheelItems) {
			const transform = `translateZ(${-radius()}px) rotateX(${itemAngle() * normalizedScroll}deg)`;
			wheelItems.style.transform = transform;

			wheelItems.childNodes.forEach((node) => {
				const li = node as HTMLLIElement;
				const distance = Math.abs(Number(li.dataset.index) - normalizedScroll);
				li.style.visibility = distance > quarterCount() ? "hidden" : "visible";
			});
		}

		const highlightList = highlightListRef();

		if (highlightList) {
			highlightList.style.transform = `translateY(${-normalizedScroll * props.optionItemHeight}px)`;
		}

		return normalizedScroll;
	};

	const cancelAnimation = () => {
		cancelAnimationFrame(moveId);
	};

	const animateScroll = (
		startScroll: number,
		endScroll: number,
		duration: number,
		onComplete?: () => void,
	) => {
		if (startScroll === endScroll || duration === 0) {
			scrollTo(startScroll);
			return;
		}

		const startTime = performance.now();
		const totalDistance = endScroll - startScroll;

		const tick = (currentTime: number) => {
			const elapsed = (currentTime - startTime) / 1000;

			if (elapsed < duration) {
				const progress = easeOutCubic(elapsed / duration);
				scrollId = scrollTo(startScroll + progress * totalDistance);
				moveId = requestAnimationFrame(tick);
			} else {
				cancelAnimation();
				scrollId = scrollTo(endScroll);
				onComplete?.();
			}
		};

		requestAnimationFrame(tick);
	};

	const selectByScroll = (scroll: number) => {
		const normalized = normalizeScroll(scroll) | 0;

		const boundedScroll = props.infinite
			? normalized
			: Math.min(Math.max(normalized, 0), options().length - 1);

		if (!props.infinite && boundedScroll !== scroll) {
			return;
		}

		scrollId = scrollTo(boundedScroll);
		const selected = options()[scrollId];

		const oldValue = value();

		setValue(() => selected.value);

		if (selected.value !== oldValue && props.onValueChange) {
			props.onValueChange(selected.value);
		}
	};

	const selectByValue = (value: T) => {
		const index = options().findIndex((opt) => opt.value === value);

		if (index === -1) {
			console.error("Invalid value selected:", value);
			return;
		}

		cancelAnimation();
		selectByScroll(index);
	};

	const scrollByStep = (step: number) => {
		const startScroll = scrollId;
		let endScroll = startScroll + step;

		if (props.infinite) {
			endScroll = Math.round(endScroll);
		} else {
			endScroll = clamp(Math.round(endScroll), 0, options().length - 1);
		}

		const distance = Math.abs(endScroll - startScroll);
		if (distance === 0) return;

		const duration = Math.sqrt(distance / props.scrollSensitivity);

		cancelAnimation();
		animateScroll(startScroll, endScroll, duration, () => {
			selectByScroll(scrollId);
		});
	};

	const handleWheelItemClick = (clientY: number) => {
		const container = containerRef();

		if (!container) {
			console.error("Container reference is not set.");
			return;
		}

		const { top } = container.getBoundingClientRect();
		const clickOffsetY = clientY - top;

		const clickedSegmentIndex = wheelSegmentPositions().findIndex(
			([start, end]) => clickOffsetY >= start && clickOffsetY <= end,
		);

		if (clickedSegmentIndex === -1) {
			console.error("No item found for click position:", clickOffsetY);
			return;
		}

		const stepsToScroll = (quarterCount() - clickedSegmentIndex - 1) * -1;
		scrollByStep(stepsToScroll);
	};

	const updateScrollDuringDrag = (e: MouseEvent | TouchEvent) => {
		try {
			const currentY =
				(e instanceof MouseEvent ? e.clientY : e.touches?.[0]?.clientY) || 0;

			// If this is the first move after mousedown, check if it's a drag
			if (touchData.isClick) {
				const dragThreshold = 5; // pixels
				if (Math.abs(currentY - touchData.startY) > dragThreshold) {
					touchData.isClick = false;
				}
			}

			// Record current Y position with timestamp
			touchData.yList.push([currentY, Date.now()]);
			if (touchData.yList.length > 5) {
				touchData.yList.shift(); // Keep latest 5 points for velocity calc
			}

			// Calculate delta in scroll position based on drag distance
			const dragDelta = (touchData.startY - currentY) / props.optionItemHeight;
			let nextScroll = scrollId + dragDelta;

			if (props.infinite) {
				// Wrap scroll for infinite lists
				nextScroll = normalizeScroll(nextScroll);
			} else {
				const maxIndex = options().length;
				if (nextScroll < 0) {
					// Apply resistance when dragging above top
					nextScroll *= RESISTANCE;
				} else if (nextScroll > maxIndex) {
					// Apply resistance when dragging below bottom
					nextScroll = maxIndex + (nextScroll - maxIndex) * RESISTANCE;
				}
			}

			// Update visual scroll and store position
			touchData.touchScroll = scrollTo(nextScroll);
		} catch (error) {
			console.error("Error in updateScrollDuringDrag:", error);
		}
	};

	const handleDragMoveEvent = (event: MouseEvent | TouchEvent) => {
		const container = containerRef();

		if (
			!dragging &&
			!container?.contains(event.target as Node) &&
			event.target !== container
		) {
			return;
		}

		if (event.cancelable) {
			event.preventDefault();
		}

		if (options().length) {
			updateScrollDuringDrag(event);
		}
	};

	const initiateDragGesture = (event: MouseEvent | TouchEvent) => {
		try {
			dragging = true;

			const controller = new AbortController();
			const { signal } = controller;

			dragController = controller;

			// Listen to movement events
			const passiveOpts = { signal, passive: false };
			containerRef()?.addEventListener(
				"touchmove",
				handleDragMoveEvent,
				passiveOpts,
			);
			document.addEventListener("mousemove", handleDragMoveEvent, passiveOpts);

			const startY =
				(event instanceof MouseEvent
					? event.clientY
					: event.touches?.[0]?.clientY) || 0;

			touchData.startY = startY;
			touchData.yList = [[startY, Date.now()]];
			touchData.touchScroll = scrollId;
			touchData.isClick = true;

			// Stop any ongoing scroll animation
			cancelAnimation();
		} catch (error) {
			console.error("Error in initiateDragGesture:", error);
		}
	};

	const handleDragStartEvent = (e: MouseEvent | TouchEvent) => {
		const isTargetValid =
			!!containerRef()?.contains(e.target as Node) ||
			e.target === containerRef();

		if ((dragging || isTargetValid) && e.cancelable) {
			e.preventDefault();
			if (options().length) {
				initiateDragGesture(e);
			}
		}
	};

	const decelerateAndAnimateScroll = (initialVelocity: number) => {
		const currentScroll = scrollId;
		let targetScroll = currentScroll;
		let deceleration =
			initialVelocity > 0 ? -baseDeceleration() : baseDeceleration();
		let duration = 0;

		if (props.infinite) {
			// Infinite mode: apply uniform deceleration to calculate scroll distance
			duration = Math.abs(initialVelocity / deceleration);
			const scrollDistance =
				initialVelocity * duration + 0.5 * deceleration * duration * duration;
			targetScroll = Math.round(currentScroll + scrollDistance);
		} else if (currentScroll < 0 || currentScroll > options().length - 1) {
			// Out-of-bounds: snap back to nearest valid scroll index
			const target = clamp(currentScroll, 0, options().length - 1);
			const scrollDistance = currentScroll - target;
			deceleration = snapBackDeceleration;
			duration = Math.sqrt(Math.abs(scrollDistance / deceleration));
			initialVelocity = deceleration * duration;
			initialVelocity = currentScroll > 0 ? -initialVelocity : initialVelocity;
			targetScroll = target;
		} else {
			// Normal decelerated scroll within bounds
			duration = Math.abs(initialVelocity / deceleration);
			const scrollDistance =
				initialVelocity * duration + 0.5 * deceleration * duration * duration;
			targetScroll = Math.round(currentScroll + scrollDistance);
			targetScroll = clamp(targetScroll, 0, options().length - 1);

			const adjustedDistance = targetScroll - currentScroll;
			duration = Math.sqrt(Math.abs(adjustedDistance / deceleration));
		}

		// Start animation to target scroll position with calculated duration
		animateScroll(currentScroll, targetScroll, duration, () => {
			selectByScroll(scrollId); // Ensure selected item updates at end
		});

		// Fallback selection update (in case animation callback fails)
		selectByScroll(scrollId);
	};

	const finalizeDragAndStartInertiaScroll = () => {
		try {
			dragController?.abort();
			dragController = null;

			// If it was a click (no significant movement), handle it as a click
			if (touchData.isClick) {
				handleWheelItemClick(touchData.startY);
				return;
			}

			const yList = touchData.yList;
			let velocity = 0;

			if (yList.length > 1) {
				const len = yList.length;
				const [startY, startTime] = yList[len - 2] ?? [0, 0];
				const [endY, endTime] = yList[len - 1] ?? [0, 0];

				const timeDiff = endTime - startTime;

				if (timeDiff > 0) {
					const distance = startY - endY;
					const velocityPerSecond =
						((distance / props.optionItemHeight) * 1000) / timeDiff;

					const maxVelocity = MAX_VELOCITY;
					const direction = velocityPerSecond > 0 ? 1 : -1;
					const absVelocity = Math.min(
						Math.abs(velocityPerSecond),
						maxVelocity,
					);
					velocity = absVelocity * direction;
				}
			}

			if (touchData.touchScroll !== undefined) {
				scrollId = touchData.touchScroll;
			}

			decelerateAndAnimateScroll(velocity);
		} catch (error) {
			console.error("Error in finalizeDragAndStartInertiaScroll:", error);
		} finally {
			dragging = false;
		}
	};

	const handleDragEndEvent = (event: MouseEvent | TouchEvent) => {
		if (!options().length) return;

		const isTargetValid =
			!!containerRef()?.contains(event.target as Node) ||
			event.target === containerRef();

		if ((dragging || isTargetValid) && event.cancelable) {
			event.preventDefault();
			finalizeDragAndStartInertiaScroll();
		}
	};

	const scrollByWheel = (event: WheelEvent) => {
		event.preventDefault();

		const now = Date.now();
		if (now - lastWheelTime < 100) return;

		const direction = Math.sign(event.deltaY);
		if (!direction) return;

		lastWheelTime = now;
		scrollByStep(direction);
	};

	const handleWheelEvent = (event: WheelEvent) => {
		if (!options().length || !containerRef()) return;

		const isTargetValid =
			containerRef()?.contains(event.target as Node) ||
			event.target === containerRef();

		if ((dragging || isTargetValid) && event.cancelable) {
			event.preventDefault();
			scrollByWheel(event);
		}
	};

	createEffect(() => {
		const container = containerRef();
		if (!container) return;

		const opts = { passive: false };

		container.addEventListener("touchstart", handleDragStartEvent, opts);
		container.addEventListener("touchend", handleDragEndEvent, opts);
		container.addEventListener("wheel", handleWheelEvent, opts);
		document.addEventListener("mousedown", handleDragStartEvent, opts);
		document.addEventListener("mouseup", handleDragEndEvent, opts);

		return () => {
			container.removeEventListener("touchstart", handleDragStartEvent);
			container.removeEventListener("touchend", handleDragEndEvent);
			container.removeEventListener("wheel", handleWheelEvent);
			document.removeEventListener("mousedown", handleDragStartEvent);
			document.removeEventListener("mouseup", handleDragEndEvent);
		};
	});

	createEffect(() => {
		selectByValue(value());
	});

	return (
		<div
			ref={setContainerRef}
			data-rwp
			style={{ height: `${containerHeight()}px` }}
		>
			<ul ref={setWheelItemsRef} data-rwp-options>
				<For each={wheelItems()}>
					{(entry) => (
						<li
							class={props.classNames?.optionItem}
							data-slot="option-item"
							data-rwp-option
							data-index={entry.index}
							style={{
								top: `${-halfItemHeight()}px`,
								height: `${props.optionItemHeight}px`,
								"line-height": `${props.optionItemHeight}px`,
								transform: `rotateX(${entry.angle}deg) translateZ(${radius()}px)`,
								visibility: "hidden",
							}}
						>
							{entry.item.label}
						</li>
					)}
				</For>
			</ul>

			<div
				class={props.classNames?.highlightWrapper}
				data-rwp-highlight-wrapper
				data-slot="highlight-wrapper"
				style={{
					height: `${props.optionItemHeight}px`,
					"line-height": `${props.optionItemHeight}px`,
				}}
			>
				<ul
					ref={setHighlightListRef}
					data-rwp-highlight-list
					style={{
						top: props.infinite ? `${-props.optionItemHeight}px` : undefined,
					}}
				>
					<For each={highlightItems()}>
						{(entry) => (
							<li
								class={props.classNames?.highlightItem}
								data-slot="highlight-item"
								data-rwp-highlight-item
								style={{ height: `${props.optionItemHeight}px` }}
							>
								{entry.item.label}
							</li>
						)}
					</For>
				</ul>
			</div>
		</div>
	);
}

export {
	WheelPicker,
	type WheelPickerOption,
	type WheelPickerProps,
	type WheelPickerValue,
	WheelPickerWrapper,
};

export { type WheelPickerClassNames } from "./types";
