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
import { CloseButton } from "@kobalte/core/dialog";
import { useStepper } from "../stepper/stepper-context";
import type { SetupForm } from "@/routes/setup";

const CycleLength: Component = () => {
	const context = useStepper<SetupForm>();

	const lowerBound = () => context.form.cycle_length.lower;
	const upperBound = () => context.form.cycle_length.upper;

	const formatWheelItems = (value: number) => ({
		label: value.toString().padStart(2, "0"),
		value: value,
	});

	const lowerRange = Array.from(_.range(5, 89, formatWheelItems));
	const upperRange = Array.from(_.range(6, 90, formatWheelItems));

	const setLowerBound = (value: number) => {
		const upper = upperBound();

		if (upper <= value) {
			context.setForm("cycle_length", "upper", value + 1);
		}

		context.setForm("cycle_length", "lower", value);
	};

	const setUpperBound = (value: number) => {
		const lower = lowerBound();

		if (lower >= value) {
			context.setForm("cycle_length", "lower", value - 1);
		}

		context.setForm("cycle_length", "upper", value);
	};

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
						<CloseButton as={Button}>Skip for now</CloseButton>
						<CloseButton as={Button} class="bg-zinc-500">
							I'll pick
						</CloseButton>
					</DialogFooter>
				</DialogContent>
			</Dialog>
		</section>
	);
};

export default CycleLength;
