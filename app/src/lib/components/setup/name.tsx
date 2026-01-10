import type { Component } from "solid-js";
import type { SetupForm } from "@/routes/setup";
import { useStepper } from "../stepper/stepper-context";
import { TextField, TextFieldDescription, TextFieldInput } from "../text";

const Name: Component = () => {
	const context = useStepper<SetupForm>();

	const handleInput = (text: string) => context.setForm("name", text);

	return (
		<section>
			<h2 class="text-3xl font-semibold">What is your name?</h2>

			<TextField class="mt-8" value={context.form.name} onChange={handleInput}>
				<TextFieldInput
					class="focus-visible:border-cycle-primary"
					placeholder="Jane Doe"
				/>

				<TextFieldDescription>
					Periodt will only store this information locally and will never sell
					your data
				</TextFieldDescription>
			</TextField>
		</section>
	);
};

export default Name;
