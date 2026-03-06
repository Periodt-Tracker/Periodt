import { FaSolidCircleQuestion } from "solid-icons/fa";
import type { Component } from "solid-js";
import {
	Dialog,
	DialogContent,
	DialogTitle,
	DialogTrigger,
} from "@/lib/components/dialog";
import blob from "@/assets/question/question_512.png";

const HelpMenu: Component = () => {
	return (
		<Dialog>
			<DialogTrigger class="transition-all active:scale-80">
				<FaSolidCircleQuestion class="size-6" />
			</DialogTrigger>

			<DialogContent class="flex flex-col gap-4">
				<DialogTitle>Kill me</DialogTitle>

				<img class="h-60 mx-auto w-fit" src={blob} alt="Question blob" />
			</DialogContent>
		</Dialog>
	);
};

export default HelpMenu;
