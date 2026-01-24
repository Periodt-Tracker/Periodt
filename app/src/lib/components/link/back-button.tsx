import type { PolymorphicProps } from "@kobalte/core";
import * as KobalteButton from "@kobalte/core/button";
import type { JSX, ValidComponent } from "solid-js";
import { useNavigator } from "@/lib/navigation/navigator-context";

type BackButtonProps<T extends ValidComponent = "button"> = KobalteButton.ButtonRootProps<T> & {
	class?: string | undefined;
	children?: JSX.Element;
};

const BackButton = <T extends ValidComponent = "button">(props: PolymorphicProps<T, BackButtonProps<T>>) => {
	const navigator = useNavigator();

	return <KobalteButton.Root onClick={navigator.pop} {...(props as BackButtonProps)} />;
};

export default BackButton;
