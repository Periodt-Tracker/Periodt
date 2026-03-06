import { FaSolidCalendar, FaSolidGear, FaSolidHouse } from "solid-icons/fa";
import { type Component, createSignal } from "solid-js";
import SymptomDrawer from "../symptoms";
import Button from "../button";
import { useNavigator } from "@/lib/navigation/navigator-context";

const tabs = [
	{
		key: "home",
		icon: FaSolidHouse,
	},
	{
		key: "calendar",
		icon: FaSolidCalendar,
	},
	{
		key: "settings",
		icon: FaSolidGear,
	},
] as const;

export type TabType = (typeof tabs)[keyof typeof tabs];

const Navbar: Component = () => {
	const navigator = useNavigator();

	return (
		<div class="fixed bottom-0 flex flex-row p-4 gap-6 w-fit left-0 right-0 ml-auto mr-auto">
			<div class="bg-black text-white rounded-full grow px-4 flex flex-row gap-4 shadow-lg place-items-center">
				<Button
					onClick={() => navigator.setPage("home")}
					class="flex gap-2 bg-cycle-primary"
				>
					<FaSolidHouse class="size-6" />
					Home
				</Button>
				<FaSolidCalendar
					onClick={() => navigator.setPage("history")}
					class="size-6"
				/>
				<FaSolidGear class="size-6 mr-2" />
			</div>

			<SymptomDrawer />
		</div>
	);
};

export default Navbar;
