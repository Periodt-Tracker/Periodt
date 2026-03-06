import type { IconTypes } from "solid-icons";

import type { Component, ComponentProps } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

export interface SettingsTabIconProps extends ComponentProps<"div"> {
	icon: IconTypes;
}

const SettingsTabIcon: Component<SettingsTabIconProps> = (props) => {
	const [, rest] = splitProps(props, ["class", "icon"]);

	return (
		<div
			class={merge("p-4 rounded-full place-items-center", props.class)}
			{...rest}
		>
			<props.icon class="text-white" size={18} />
		</div>
	);
};

export default SettingsTabIcon;
