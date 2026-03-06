import type { Component } from "solid-js";
import {
	Drawer,
	DrawerClose,
	DrawerContent,
	DrawerDescription,
	DrawerFooter,
	DrawerHeader,
	DrawerPage,
	DrawerTitle,
	DrawerTrigger,
} from "../drawer";
import Button from "../button";
import { FaSolidPlus } from "solid-icons/fa";
import { Repeat } from "@solid-primitives/range";
import DischargePage from "../daily-log/pages/discharge";

const SymptomDrawer: Component = () => {
	const today = () => {
		const today = new Date();

		const options = {
			weekday: "long",
			day: "numeric",
			month: "long",
		} as const;

		return new Intl.DateTimeFormat("en-GB", options).format(today);
	};

	return (
		<Drawer>
			<DrawerTrigger as={Button} class="bg-black p-6">
				<FaSolidPlus class="size-6" />
			</DrawerTrigger>

			<DrawerPage class="h-full flex flex-col">
				<DrawerHeader>
					<DrawerDescription>{today()}</DrawerDescription>
					<DrawerTitle class="text-2xl">How are you feeling?</DrawerTitle>
				</DrawerHeader>

				<DischargePage />

				{/* <section class="grid grid-cols-2 gap-4 p-4"> */}
				{/* 	<Repeat times={6}> */}
				{/* 		<div class="aspect-square w-full rounded-2xl bg-cycle-primary"></div> */}
				{/* 	</Repeat> */}
				{/* </section> */}

				<DrawerFooter class="mt-auto">
					<Button>Submit</Button>
				</DrawerFooter>
			</DrawerPage>
		</Drawer>
	);
};

export default SymptomDrawer;
