import type { PolymorphicProps } from "@kobalte/core";
import * as TextFieldPrimitive from "@kobalte/core/text-field";

import type { ValidComponent } from "solid-js";
import { mergeProps, splitProps } from "solid-js";
import { merge } from "@/lib/utilities/class";

type TextFieldRootProps<T extends ValidComponent = "div"> = TextFieldPrimitive.TextFieldRootProps<T> & {
  class?: string | undefined;
};

const TextField = <T extends ValidComponent = "div">(props: PolymorphicProps<T, TextFieldRootProps<T>>) => {
  const [local, others] = splitProps(props as TextFieldRootProps, ["class"]);
  return <TextFieldPrimitive.Root class={merge("flex flex-col gap-1", local.class)} {...others} />;
};

type TextFieldInputProps<T extends ValidComponent = "input"> = TextFieldPrimitive.TextFieldInputProps<T> & {
  class?: string | undefined;
  type?:
  | "button"
  | "checkbox"
  | "color"
  | "date"
  | "datetime-local"
  | "email"
  | "file"
  | "hidden"
  | "image"
  | "month"
  | "number"
  | "password"
  | "radio"
  | "range"
  | "reset"
  | "search"
  | "submit"
  | "tel"
  | "text"
  | "time"
  | "url"
  | "week";
};

const TextFieldInput = <T extends ValidComponent = "input">(rawProps: PolymorphicProps<T, TextFieldInputProps<T>>) => {
  const props = mergeProps<TextFieldInputProps<T>[]>({ type: "text" }, rawProps);
  const [local, others] = splitProps(props as TextFieldInputProps, ["type", "class"]);

  return (
    <TextFieldPrimitive.Input
      type={local.type}
      class={merge(
        "flex h-10 w-full border-b-2 border-input bg-transparent px-0 py-2 ring-offset-background",
        "file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground",
        "focus-visible:outline-none focus-visible:border-current focus-visible:border-b-3",
        "disabled:cursor-not-allowed disabled:opacity-50 data-[invalid]:border-error-foreground data-[invalid]:text-error-foreground transition-all",
        local.class,
      )}
      {...others}
    />
  );
};

type TextFieldTextAreaProps<T extends ValidComponent = "textarea"> = TextFieldPrimitive.TextFieldTextAreaProps<T> & {
  class?: string | undefined;
};

const TextFieldTextArea = <T extends ValidComponent = "textarea">(
  props: PolymorphicProps<T, TextFieldTextAreaProps<T>>,
) => {
  const [local, others] = splitProps(props as TextFieldTextAreaProps, ["class"]);
  return (
    <TextFieldPrimitive.TextArea
      class={merge(
        "flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
        local.class,
      )}
      {...others}
    />
  );
};

type TextFieldLabelProps<T extends ValidComponent = "label"> = TextFieldPrimitive.TextFieldLabelProps<T> & {
  class?: string | undefined;
};

const TextFieldLabel = <T extends ValidComponent = "label">(props: PolymorphicProps<T, TextFieldLabelProps<T>>) => {
  const [local, others] = splitProps(props as TextFieldLabelProps, ["class"]);
  return (
    <TextFieldPrimitive.Label
      class={merge(
        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed data-[invalid]:text-destructive peer-disabled:opacity-70",
        local.class,
      )}
      {...others}
    />
  );
};

type TextFieldDescriptionProps<T extends ValidComponent = "div"> = TextFieldPrimitive.TextFieldDescriptionProps<T> & {
  class?: string | undefined;
};

const TextFieldDescription = <T extends ValidComponent = "div">(
  props: PolymorphicProps<T, TextFieldDescriptionProps<T>>,
) => {
  const [local, others] = splitProps(props as TextFieldDescriptionProps, ["class"]);

  return (
    <TextFieldPrimitive.Description
      class={merge(
        "leading-none mt-2 peer-disabled:cursor-not-allowed peer-disabled:opacity-70 font-light text-muted-foreground",
        local.class,
      )}
      {...others}
    />
  );
};

type TextFieldErrorMessageProps<T extends ValidComponent = "div"> = TextFieldPrimitive.TextFieldErrorMessageProps<T> & {
  class?: string | undefined;
};

const TextFieldErrorMessage = <T extends ValidComponent = "div">(
  props: PolymorphicProps<T, TextFieldErrorMessageProps<T>>,
) => {
  const [local, others] = splitProps(props as TextFieldErrorMessageProps, ["class"]);
  return (
    <TextFieldPrimitive.ErrorMessage
      class={merge(
        "leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 text-xs text-destructive",
        local.class,
      )}
      {...others}
    />
  );
};

export { TextField, TextFieldInput, TextFieldTextArea, TextFieldLabel, TextFieldDescription, TextFieldErrorMessage };
