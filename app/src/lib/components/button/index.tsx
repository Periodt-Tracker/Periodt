import { Button as KobalteButton } from "@kobalte/core/button";
import { type ComponentProps, type ParentComponent, splitProps } from "solid-js";
import { merge } from "@/lib/utilities/class";

const Button: ParentComponent<ComponentProps<"button">> = (props) => {
  const [local, rest] = splitProps(props, ["children", "class"]);

  return (
    <KobalteButton
      class={merge(
        "bg-period-primary rounded-full text-white transition-all py-2 px-4 text-lg font-semibold",
        "active:scale-95 disabled:bg-accent-50 hover:bg-brand-200",
        "focus-visible:outline-solid outline-none outline-offset-2 outline-3 outline-brand-100",
        local.class,
      )}
      {...rest}
    >
      {props.children}
    </KobalteButton>
  );
};


export default Button;
