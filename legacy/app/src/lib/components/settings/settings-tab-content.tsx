import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const SettingsTabContent: ParentComponent<ComponentProps<"section">> = (
	props,
) => {
	const [, rest] = splitProps(props, ["children", "class"]);

	return (
		<section class={merge("flex flex-col grow", props.class)} {...rest}>
			{props.children}
		</section>
	);
};

export default SettingsTabContent;
