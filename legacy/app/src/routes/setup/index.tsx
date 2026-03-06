import { createSignal, Show, type Component } from "solid-js";
import blob from "@/assets/blob.svg";
import CycleLength from "@/lib/components/setup/cycle";
import Name from "@/lib/components/setup/name";
import PeriodLength from "@/lib/components/setup/period-length";
import Stepper from "@/lib/components/stepper";
import type { NumberRange } from "@/lib/utilities/types";
import { useSettings } from "@/lib/settings";
import Button from "@/lib/components/button";
import { useLocale } from "@/lib/i18n/i18n-context";
import LastPeriod from "@/lib/components/setup/last-period";

export interface SetupForm {
	name: string;
	period_length: NumberRange;
	cycle_length: NumberRange;
}

const initial_form = {
	name: "",
	period_length: { lower: 4, upper: 6 },
	cycle_length: { lower: 26, upper: 28 },
} as const;

const SetupPage: Component = (props) => {
	const settings = useSettings();
	const { t } = useLocale();

	const [started, setStarted] = createSignal(false);

	const handleComplete = (form: SetupForm) => {
		settings.setSettings({ setup_complete: true, ...form });
	};

	return (
		<main class="w-svw h-svh bg-cycle-secondary flex flex-col">
			<section class="grid place-items-center grow">
				<section class="flex flex-col gap-8 place-items-center">
					<span class="text-white text-5xl font-semibold animate-in zoom-in-70 duration-700 text-center">
						{t("setup.welcome")}
					</span>

					<img
						class="w-48 h-48 animate-in zoom-in-70 duration-700"
						src={blob}
						alt="blob"
					/>
				</section>
			</section>

			<Show
				when={started()}
				fallback={
					<div class="m-4">
						<Button class="w-full" onClick={() => setStarted(true)}>
							{t("setup.start")}
						</Button>
					</div>
				}
			>
				<section class="mt-auto mx-4 bg-white rounded-t-[48px] shadow-2xl p-8 min-h-[40vh] animate-in slide-in-from-bottom-100">
					<Stepper
						initialValue={initial_form}
						initialPage={0}
						pages={[
							{
								component: Name,
								valid: (form) => form.name !== "",
							},
							{
								component: CycleLength,
								valid: (form) =>
									form.cycle_length.lower <
									form.cycle_length.upper,
							},
							{
								component: PeriodLength,
								valid: (form) =>
									form.period_length.lower <
									form.period_length.upper,
							},
							{
								component: LastPeriod,
								valid: () => true,
							},
						]}
						onComplete={handleComplete}
					/>
				</section>
			</Show>
		</main>
	);
};

export default SetupPage;
