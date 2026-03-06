import {
	splitProps,
	type ComponentProps,
	type ParentComponent,
	type ParentProps,
} from "solid-js";
import { merge } from "@/lib/utilities/class";
import Button from "../button";

export interface RadioGridButtonProps<T extends string | number = string>
	extends ComponentProps<"button"> {
	value: T;
}

const RadioGridButton = (props: ParentProps<RadioGridButtonProps>) => {
	const [, rest] = splitProps(props, ["class", "children"]);

	return (
		<Button
			data-active={props.active}
			class={merge(
				"relative aspect-square w-38 shrink-0 rounded-2xl outline-cycle-primary outline-4 m-2",
				"data-[active=true]:outline-solid disabled:grayscale",
				props.class,
			)}
			{...rest}
		>
			{props.children}
		</Button>
	);
};
