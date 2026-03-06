import {
	batch,
	type ComponentProps,
	createSignal,
	For,
	type ParentComponent,
	Show,
	splitProps,
} from "solid-js";
import { discharge_colour, discharge_rules } from "@/lib/symptoms/constants";
import type {
	DischargeColour,
	DischargeConsistency,
	DischargeOdor,
} from "@/lib/symptoms/types";
import { merge } from "@/lib/utilities/class";
import { keys, values } from "@/lib/utilities/object";
import Button from "../../button";

const DischargeButton: ParentComponent<
	ComponentProps<"button"> & { active: boolean }
> = (props) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<Button
			data-active={props.active}
			class={merge(
				"relative aspect-square w-38 shrink-0 rounded-2xl outline-cycle-primary outline-4 m-2",
				"data-[active=true]:outline-solid disabled:grayscale",
				props.class,
			)}
			{...rest}
		>
			{props.children}
		</Button>
	);
};

const DischargePage = () => {
	const [colour, __setColour] = createSignal<DischargeColour>();
	const [consistency, __setConsistency] = createSignal<DischargeConsistency>();
	const [odor, setOdor] = createSignal<DischargeOdor>();

	const setColour = (value: DischargeColour | undefined) => {
		batch(() => {
			__setConsistency(undefined);
			setOdor(undefined);
		});

		__setColour(value);
	};

	const setConsistency = (value: DischargeConsistency | undefined) => {
		setOdor(undefined);
		__setConsistency(value);
	};

	const colours = values(discharge_colour);

	const consistency_map = () => {
		const discharge_colour = colour();

		if (!discharge_colour) {
			return undefined;
		}

		return discharge_rules[discharge_colour];
	};

	const consistencies = () => {
		const map = consistency_map();

		if (!map) {
			return undefined;
		}

		return keys(map);
	};

	const odor_map = () => {
		const previous = consistency_map();

		if (!previous) {
			return undefined;
		}

		const value = consistency();

		if (!value) {
			return undefined;
		}

		return previous[value];
	};

	const odors = () => {
		const map = odor_map();

		if (!map) {
			return undefined;
		}

		return keys(map);
	};

	const risks = () => {
		const map = odor_map();
		const value = odor();

		if (!map || !value) {
			return [];
		}

		return map[value]?.risks ?? [];
	};

	return (
		<section class="px-2">
			{/* <section class="grid grid-cols-2 gap-4 p-4"> */}
			{/* 	<Repeat times={6}> */}
			{/* 		<div class="aspect-square w-full rounded-2xl bg-cycle-primary"></div> */}
			{/* 	</Repeat> */}
			{/* </section> */}
			<section class="flex flex-row overflow-x-scroll">
				<For each={colours}>
					{(item) => (
						<DischargeButton
							active={colour() === item}
							onClick={() => setColour(item)}
							class="aspect-square w-38 shrink-0 rounded-2xl"
						>
							<span>{item}</span>
						</DischargeButton>
					)}
				</For>
			</section>

			<section class="flex flex-row overflow-x-scroll">
				<For each={consistencies()}>
					{(item) => (
						<DischargeButton
							active={consistency() === item}
							onClick={() => setConsistency(item)}
							class="aspect-square w-38 shrink-0 rounded-2xl"
						>
							{item}
						</DischargeButton>
					)}
				</For>
			</section>

			<Show when={odors()}>
				<span>Odor</span>

				<section class="flex flex-row overflow-x-scroll">
					<For each={odors()}>
						{(item) => (
							<DischargeButton
								active={odor() === item}
								onClick={() => setOdor(item)}
								class="aspect-square w-38 shrink-0 rounded-2xl"
							>
								{item}
							</DischargeButton>
						)}
					</For>
				</section>
			</Show>

			<For each={risks()}>{(risk) => JSON.stringify(risk)}</For>

			<span class="mt-auto">Skip</span>
		</section>
	);
};

export default DischargePage;
