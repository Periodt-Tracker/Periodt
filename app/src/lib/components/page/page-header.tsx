import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

const PageHeader: ParentComponent<ComponentProps<"div">> = (props) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<div
			class={merge(
				"fixed top-0 left-0 p-4 w-full bg-cycle-secondary text-cycle-primary flex flex-row place-items-center",
				props.class,
			)}
			{...rest}
		>
			{props.children}
		</div>
	);
};

export default PageHeader;
