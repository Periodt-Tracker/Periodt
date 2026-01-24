import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const SettingsTabDescription: ParentComponent<ComponentProps<"span">> = (
	props,
) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<span class={merge("opacity-70", props.class)} {...rest}>
			{props.children}
		</span>
	);
};

export default SettingsTabDescription;
