import * as _ from "radash";

import { type Component, createSignal } from "solid-js";
import { WheelPicker, WheelPickerWrapper } from "../number-wheel/scroll-picker";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogTitle,
	DialogTrigger,
} from "../dialog";
import Button from "../button";

const CycleLength: Component = () => {
	const [lowerBound, __setLowerBound] = createSignal(26);
	const [upperBound, __setUpperBound] = createSignal(28);

	const formatWheelItems = (value: number) => ({
		label: value.toString().padStart(2, "0"),
		value: value,
	});

	const lowerRange = Array.from(_.range(5, 89, formatWheelItems));
	const upperRange = Array.from(_.range(6, 90, formatWheelItems));

	const setLowerBound = (value: number) => {
		const upper = upperBound();

		if (upper <= value) {
			__setUpperBound(value + 1);
		}

		__setLowerBound(value);
	};

	const setUpperBound = (value: number) => {
		const lower = lowerBound();

		if (lower >= value) {
			__setLowerBound(value - 1);
		}

		__setUpperBound(value);
	};

	// const upperRange = () => {
	// 	const lower = lowerBound();
	//
	// 	return Array.from(_.range(lower + 1, 90, formatWheelItems));
	// };

	return (
		<section class="flex flex-col">
			<h2 class="text-3xl font-semibold">How long is your usual cycle?</h2>

			<WheelPickerWrapper class="w-56 mt-4 rounded-md flex flex-row gap-4 place-items-center justify-center">
				<WheelPicker
					options={lowerRange}
					value={lowerBound()}
					onValueChange={setLowerBound}
					classNames={{
						optionItem: "text-zinc-400 dark:text-zinc-500",
						highlightWrapper: "bg-zinc-100 text-zinc-950 rounded-full",
					}}
					visibleCount={10}
				/>

				<span class="my-auto">to</span>

				<WheelPicker
					options={upperRange}
					value={upperBound()}
					onValueChange={setUpperBound}
					classNames={{
						optionItem: "text-zinc-400 dark:text-zinc-500",
						highlightWrapper: "bg-zinc-100 text-zinc-950 rounded-full",
					}}
					visibleCount={10}
				/>

				<span class="my-auto">Days</span>
			</WheelPickerWrapper>

			<Dialog>
				<DialogTrigger class="mx-auto">Not sure?</DialogTrigger>

				<DialogContent>
					<DialogTitle>Not sure how long your cycle is?</DialogTitle>

					<DialogDescription>
						It's completely okay, we're here to help you find out what's normal
						for you,
					</DialogDescription>

					<DialogFooter class="flex flex-col gap-4">
						<Button>Skip for now</Button>
						<Button class="bg-zinc-300">I'll pick</Button>
					</DialogFooter>
				</DialogContent>
			</Dialog>
		</section>
	);
};

export default CycleLength;
