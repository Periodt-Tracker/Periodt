import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const PageHeaderTitle: ParentComponent<ComponentProps<"h2">> = (props) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<h2
			class={merge(
				"text-cycle-primary text-2xl font-semibold mx-auto",
				props.class,
			)}
			{...rest}
		>
			{props.children}
		</h2>
	);
};

export default PageHeaderTitle;
