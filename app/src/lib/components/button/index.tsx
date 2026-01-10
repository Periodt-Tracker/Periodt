import type { PolymorphicProps } from "@kobalte/core";
import * as KobalteButton from "@kobalte/core/button";

import type { JSX, ValidComponent } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";

type ButtonProps<T extends ValidComponent = "button"> =
	KobalteButton.ButtonRootProps<T> & {
		class?: string | undefined;
		children?: JSX.Element;
	};

const Button = <T extends ValidComponent = "button">(
	props: PolymorphicProps<T, ButtonProps<T>>,
) => {
	const [, rest] = splitProps(props as ButtonProps, ["children", "class"]);

	return (
		<KobalteButton.Root
			class={merge(
				"bg-cycle-primary rounded-full text-white transition-all py-2 px-4 text-lg font-semibold",
				"active:scale-95 disabled:bg-zinc-500 hover:bg-brand-200",
				"focus-visible:outline-solid outline-none outline-offset-2 outline-3 outline-brand-100",
				props.class,
			)}
			{...rest}
		>
			{props.children}
		</KobalteButton.Root>
	);
};

export default Button;
