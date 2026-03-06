import { type Component, Show } from "solid-js";
import blob from "@/assets/question/question_512.png";
import { useCycle } from "@/lib/cycle/cycle-context";
import { useLocale } from "@/lib/i18n";

const CurrentPhase: Component = () => {
	const { t } = useLocale();
	const context = useCycle();

	const phase = () => context.current_phase();

	return (
		<Show when={phase()}>
			{(phase) => (
				<div class="flex flex-col gap-2">
					<h3 class="font-semibold text-2xl text-center">
						Current Phase: {t(`phase.${phase()}.name`)}
					</h3>

					<img class="h-40 m-auto" alt="period" src={blob} />

					<span class="opacity-60 text-center">
						{t(`phase.${phase()}.description`)}
					</span>
				</div>
			)}
		</Show>
	);
};

export default CurrentPhase;
