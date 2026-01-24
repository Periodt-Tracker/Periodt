import type { ComponentProps, ParentComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

export interface SettingsTabProps extends ComponentProps<"div"> {
	href?: string;
}

const SettingsTab: ParentComponent<SettingsTabProps> = (props) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<div
			class={merge(
				"group p-4 first:rounded-t-4xl last:rounded-b-4xl active:bg-white transition-all text-left",
				props.class,
			)}
			{...rest}
		>
			<div class="flex flex-row gap-4 group-active:scale-95 transition-all place-items-center">
				{props.children}
			</div>
		</div>
	);
};

export default SettingsTab;
