import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const SettingsTabTitle: ParentComponent<ComponentProps<"span">> = (props) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<span class={merge("text-lg font-semibold", props.class)} {...rest}>
			{props.children}
		</span>
	);
};

export default SettingsTabTitle;
