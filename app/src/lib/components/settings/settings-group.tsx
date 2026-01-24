import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const SettingsGroup: ParentComponent<ComponentProps<"section">> = (props) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<section
			class={merge(
				"rounded-4xl bg-cycle-light flex flex-col shadow-md",
				props.class,
			)}
			{...rest}
		>
			{props.children}
		</section>
	);
};

export default SettingsGroup;
