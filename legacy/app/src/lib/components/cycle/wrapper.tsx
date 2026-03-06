import { createEffect, createSignal, Show, Suspense } from "solid-js";
import { useCycle } from "@/lib/cycle/cycle-context";
import { createTweenedSignal } from "@/lib/utilities/tween";
import CycleTimeline from "../timeline";
import CycleWheel from ".";
import Button from "../button";
import { useNavigator } from "@/lib/navigation/navigator-context";
import PeriodPicker from "../period-picker";

const CycleWrapper = () => {
	const context = useCycle();
	const navigator = useNavigator();

	// the angle in our current cycle, this should be eventually
	// consistent with the day but during scrolling should be
	// slightly off
	const progress = createTweenedSignal(0);

	const cycle = () => context.cycles()[0];

	return (
		<Suspense>
			<Show when={cycle()}>
				{(cycle2) => (
					<div class="flex flex-col gap-2">
						<section class="px-8">
							<CycleWheel cycle={cycle2()} progress={progress} />
						</section>

						<Button
							class="bg-cycle-primary mx-auto text-sm"
							onClick={() => navigator.overlay(PeriodPicker)}
						>
							Add Period
						</Button>

						<CycleTimeline cycle={cycle2()} progress={progress} />
					</div>
				)}
			</Show>
		</Suspense>
	);
};

export default CycleWrapper;
