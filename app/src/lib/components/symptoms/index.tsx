import type { Component } from "solid-js";
import {
	Drawer,
	DrawerClose,
	DrawerContent,
	DrawerDescription,
	DrawerFooter,
	DrawerHeader,
	DrawerTitle,
	DrawerTrigger,
} from "../drawer";
import Button from "../button";
import { FaSolidPlus } from "solid-icons/fa";

const SymptomDrawer: Component = () => {
	return (
		<Drawer>
			<DrawerTrigger as={Button} class="bg-black p-6">
				<FaSolidPlus class="size-6" />
			</DrawerTrigger>

			<DrawerContent class="h-[95%]">
				<DrawerHeader>
					<DrawerTitle>Are you absolutely sure?</DrawerTitle>
					<DrawerDescription>This action cannot be undone.</DrawerDescription>
				</DrawerHeader>
				<DrawerFooter>
					<Button>Submit</Button>
					<DrawerClose>
						<Button>Cancel</Button>
					</DrawerClose>
				</DrawerFooter>
			</DrawerContent>
		</Drawer>
	);
};

export default SymptomDrawer;
