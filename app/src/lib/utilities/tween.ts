import { createSignal, onCleanup } from "solid-js";

export interface TweenedSignalOptions {
	duration?: number;
	ease?: (time: number) => number;
}

export const linear = (t: number) => t;

export const createTweenedSignal = (
	initial: number,
	options: TweenedSignalOptions = {},
) => {
	const { duration = 300, ease = linear } = options;

	const [current, setCurrent] = createSignal(initial);
	const [tweened, setTweened] = createSignal(initial);

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

		setTweened(from + (to - from) * eased);

		if (t < 1) {
			raf_handle = window.requestAnimationFrame(animate);
		}
	};

	const set = (next: number) => {
		if (raf_handle) {
			window.cancelAnimationFrame(raf_handle);
		}

		from = tweened();
		to = next;
		start = 0;

		setCurrent(next);
		raf_handle = window.requestAnimationFrame(animate);
	};

	const setImmediate = (next: number) => {
		if (raf_handle) {
			window.cancelAnimationFrame(raf_handle);
		}

		setCurrent(next);
		setTweened(next);
	};

	onCleanup(() => {
		if (raf_handle) {
			window.cancelAnimationFrame(raf_handle);
		}
	});

	return {
		value: current,
		tweened,
		set,
		setImmediate,
	};
};
