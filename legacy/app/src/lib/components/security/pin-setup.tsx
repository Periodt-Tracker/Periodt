import {
	batch,
	createEffect,
	createSignal,
	Show,
	type Component,
} from "solid-js";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogTitle,
} from "@/lib/components/dialog";
import { useSettings } from "@/lib/settings";
import { pin_hash_key, security_type } from "./constants";
import { SecureStoragePlugin } from "capacitor-secure-storage-plugin";
import {
	OTPField,
	OTPFieldGroup,
	OTPFieldInput,
	OTPFieldSlot,
} from "../opt-field";
import { CloseButton } from "@kobalte/core/dialog";
import Button from "@/lib/components/button";

import * as bcrypt from "bcryptjs";

const PinSetup: Component = () => {
	const context = useSettings();

	const [open, setOpen] = createSignal(false);

	const [firstPinSet, setFirstPinSet] = createSignal(false);
	const [failedMatch, setFailedMatch] = createSignal(false);

	const [firstPin, setFirstPin] = createSignal("");

	createEffect(async () => {
		const method = context.settings.security;

		if (method !== security_type.pin) {
			return;
		}

		const pin = await SecureStoragePlugin.get({ key: pin_hash_key });

		if (pin.value) {
			return;
		}

		open();
	});

	const verifyFirst = () => {
		setFirstPinSet(true);
	};

	const verifySecond = async (value: string) => {
		const first = firstPin();

		if (value !== first) {
			batch(() => {
				setFailedMatch(true);
				setFirstPinSet(false);
			});

			return;
		}

		const hashed = await bcrypt.hash(value, 10);
		await SecureStoragePlugin.set({ key: pin_hash_key, value: hashed });

		setOpen(false);
	};

	// make sure to disable pin verification when we cancel
	// setting it so we don't have issues on next load
	//
	// we'll just use none here as a safe default
	//
	const cancel = () => {
		context.setSettings("security", security_type.none);
	};

	return (
		<Dialog open={open()} onOpenChange={setOpen}>
			<DialogContent>
				<Show
					when={!firstPinSet()}
					fallback={
						<>
							<DialogTitle>Confirm Your Pin</DialogTitle>

							<OTPField maxLength={4} onComplete={verifySecond} class="m-auto">
								<OTPFieldInput />

								<OTPFieldGroup>
									<OTPFieldSlot class="bg-white" index={0} />
									<OTPFieldSlot class="bg-white" index={1} />
									<OTPFieldSlot class="bg-white" index={2} />
									<OTPFieldSlot class="bg-white" index={3} />
								</OTPFieldGroup>
							</OTPField>

							<DialogDescription>
								Please confirm your pin so we know we got it right.
							</DialogDescription>
						</>
					}
				>
					<DialogTitle>Set Your Pin</DialogTitle>

					<OTPField
						value={firstPin()}
						onValueChange={setFirstPin}
						maxLength={4}
						onComplete={verifyFirst}
						class="m-auto"
					>
						<OTPFieldInput />

						<OTPFieldGroup>
							<OTPFieldSlot
								class="bg-white border-accent border-4 shadow-none"
								index={0}
							/>
							<OTPFieldSlot
								class="bg-white border-accent border-4 shadow-none"
								index={1}
							/>
							<OTPFieldSlot
								class="bg-white border-accent border-4 shadow-none"
								index={2}
							/>
							<OTPFieldSlot
								class="bg-white border-accent border-4 shadow-none"
								index={3}
							/>
						</OTPFieldGroup>
					</OTPField>

					<Show when={failedMatch()}>
						<DialogDescription>
							Pins did not match please try again
						</DialogDescription>
					</Show>

					<DialogDescription>
						Set a custom pin for periodt. this can be completely seperate from
						your device pin
					</DialogDescription>
				</Show>

				<DialogFooter>
					<CloseButton as={Button} onClick={cancel}>
						Cancel
					</CloseButton>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
};

export default PinSetup;
