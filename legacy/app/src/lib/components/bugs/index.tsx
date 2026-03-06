import { useSettings } from "@/lib/settings";
import { createEffect, createSignal, onCleanup, onMount, Show } from "solid-js";

import { CapacitorShake as Shake } from "@capgo/capacitor-shake";
import { Dialog, DialogContent, DialogFooter, DialogTitle } from "../dialog";
import { Switch } from "@kobalte/core/switch";
import { CloseButton } from "@kobalte/core/dialog";
import Button from "../button";

const BugReport = () => {
	const context = useSettings();

	const [open, setOpen] = createSignal(false);
	const status = () => context.settings.shake_to_report;

	const tryOpen = () => {
		const permission = status();

		if (permission === "disabled") {
			return;
		}

		setOpen(true);
	};

	createEffect(async () => {
		const permission = status();

		if (permission === "disabled") {
			return;
		}

		const listener = await Shake.addListener("shake", tryOpen);
		onCleanup(async () => listener.remove());
	});

	return (
		<Dialog>
			<DialogContent>
				<Show
					when={status() === "active"}
					fallback={
						<>
							<DialogTitle>Enable Shake Feedback</DialogTitle>

							<DialogFooter>
								<Button
									onClick={() =>
										context.setSettings("shake_to_report", "active")
									}
								>
									Send Feedback
								</Button>

								<CloseButton
									onClick={() =>
										context.setSettings("shake_to_report", "disabled")
									}
									as={Button}
								>
									Fuck you
								</CloseButton>
							</DialogFooter>
						</>
					}
				>
					<DialogTitle>Send feedback</DialogTitle>

					<CloseButton as={Button}>Submit</CloseButton>
				</Show>
			</DialogContent>
		</Dialog>
	);
};

export default BugReport;
