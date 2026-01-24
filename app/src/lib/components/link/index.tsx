import { mergeProps, type ParentComponent, splitProps } from "solid-js";
import { useNavigator } from "@/lib/navigation/navigator-context";

export interface LinkProps {
	route: string;
}

const Link: ParentComponent<LinkProps> = (__props) => {
	const navigator = useNavigator();

	const props = mergeProps({ opaque: false }, __props);
	const [, rest] = splitProps(props, ["opaque", "children"]);

	return (
		<button onClick={() => navigator.push(props.route)} type="button" {...rest}>
			{props.children}
		</button>
	);
};

export default Link;
