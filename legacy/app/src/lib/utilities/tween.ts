import { type Accessor, createSignal, onCleanup } from "solid-js";

export interface TweenOptions {
	duration?: number;
	ease?: (time: number) => number;
}

export interface TweenedSignal {
	setTweened: (next: number, options?: TweenOptions) => void;

	setImmediate: (next: number) => void;

	tweened: Accessor<number>;

	immediate: Accessor<number>;
}

export const linear = (t: number) => t;

export const createTweenedSignal = (
	initial: number,
	options: TweenOptions = {},
): TweenedSignal => {
	const { duration = 300, ease = linear } = options;

	const [immediate, __setImmediate] = createSignal(initial);
	const [tweened, __setTweened] = createSignal(initial);

	let raf_handle: number | null = null;
	let start = 0;
	let from = initial;
	let to = initial;

	const animate = (time: number) => {
		if (!start) {
			start = time;
		}

		const elapsed = time - start;
		const t = Math.min(elapsed / duration, 1);
		const eased = ease(t);

		__setTweened(from + (to - from) * eased);

		if (t < 1) {
			raf_handle = window.requestAnimationFrame(animate);
		}
	};

	const setTweened = (next: number, options?: TweenOptions) => {
		if (raf_handle) {
			window.cancelAnimationFrame(raf_handle);
		}

		from = tweened();
		to = next;
		start = 0;

		__setImmediate(next);
		raf_handle = window.requestAnimationFrame(animate);
	};

	const setImmediate = (next: number) => {
		if (raf_handle) {
			window.cancelAnimationFrame(raf_handle);
		}

		__setImmediate(next);
		__setTweened(next);
	};

	onCleanup(() => {
		if (raf_handle) {
			window.cancelAnimationFrame(raf_handle);
		}
	});

	return {
		immediate,
		tweened,
		setTweened,
		setImmediate,
	};
};
