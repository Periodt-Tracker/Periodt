import { A, useLocation, useNavigate } from "@solidjs/router";

import { FaSolidAngleLeft } from "solid-icons/fa";

import type { Component, ComponentProps } from "solid-js";
import { splitProps } from "solid-js";

import { merge } from "@/lib/utilities/class";
import BackButton from "@/lib/components/link/back-button";

const PageHeaderBackButton: Component<ComponentProps<"button">> = (props) => {
	const [, rest] = splitProps(props, ["class"]);

	return (
		<BackButton class={merge("absolute left-4", props.class)} {...rest}>
			<FaSolidAngleLeft size={24} />
		</BackButton>
	);
};

export default PageHeaderBackButton;
