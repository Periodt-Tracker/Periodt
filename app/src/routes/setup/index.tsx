import type { Component } from "solid-js";
import blob from "@/assets/blob.svg";
import Stepper from "@/lib/components/stepper";
import {
	TextField,
	TextFieldDescription,
	TextFieldInput,
} from "@/lib/components/text";
import CycleLength from "@/lib/components/setup/cycle";

const SetupPage: Component = () => {
	return (
		<main class="w-svw h-svh bg-period-secondary flex flex-col">
			<section class="grid place-items-center grow">
				<section class="flex flex-col gap-8 place-items-center">
					<span class="text-white text-5xl font-semibold animate-in zoom-in-70 duration-700 text-center">
						Welcome!
					</span>

					<img
						class="w-48 h-48 animate-in zoom-in-70 duration-700"
						src={blob}
						alt="blob"
					/>
				</section>
			</section>

			<section class="mt-auto mx-4 bg-white rounded-t-[48px] shadow-2xl p-8 h-[40vh] animate-in">
				<Stepper
					initialPage={1}
					pages={[
						<section>
							<h2 class="text-3xl font-semibold">What is your name?</h2>

							<TextField class="mt-8">
								<TextFieldInput
									class="focus-visible:border-period-primary"
									placeholder="Jane Doe"
								/>

								<TextFieldDescription>
									Periodt will only store this information locally and will
									never sell your data
								</TextFieldDescription>
							</TextField>
						</section>,
						<CycleLength />,
						<section>
							<h2 class="text-3xl font-semibold">
								How long is your usual period?
							</h2>

							<TextField class="mt-8">
								<TextFieldInput
									class="focus-visible:border-period-primary"
									placeholder="Jane Doe"
								/>

								<TextFieldDescription>
									Periodt will only store this information locally and will
									never sell your data
								</TextFieldDescription>
							</TextField>
						</section>,
					]}
				/>
			</section>
		</main>
	);
};

export default SetupPage;
