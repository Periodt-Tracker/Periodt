import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const SettingsSeperator: ParentComponent<ComponentProps<"hr">> = (props) => {
	const [, rest] = splitProps(props, ["class"]);

	return (
		<hr class={merge("border-cycle-primary mx-4", props.class)} {...rest} />
	);
};

export default SettingsSeperator;
