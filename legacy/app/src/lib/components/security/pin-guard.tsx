import { type Component, createSignal, onMount } from "solid-js";
import Button from "../button";
import { SecureStoragePlugin } from "capacitor-secure-storage-plugin";
import { pin_hash_key } from "./constants";
import {
	OTPField,
	OTPFieldGroup,
	OTPFieldInput,
	OTPFieldSlot,
} from "../opt-field";
import * as bcrypt from "bcryptjs";
import blob from "@/assets/lock/lock_512.png";

export interface PinGuardProps {
	onVerified: VoidFunction;
}

const DeviceGuard: Component<PinGuardProps> = (props) => {
	const [pin, setPin] = createSignal("");
	const [inputRef, setInputRef] = createSignal<HTMLInputElement>();

	const verify = async (value: string) => {
		const pin_hash = await SecureStoragePlugin.get({ key: pin_hash_key })
			.then((result) => result.value)
			.catch(props.onVerified);

		if (!pin_hash) {
			props.onVerified();
			return;
		}

		const valid = await bcrypt.compare(value, pin_hash);

		if (valid) {
			props.onVerified();
		} else {
			setPin("");
		}
	};

	onMount(async () => {
		const hashed = await bcrypt.hash("0000", 10);
		await SecureStoragePlugin.set({ key: pin_hash_key, value: hashed });

		const element = inputRef();

		if (!element) {
			return;
		}

		element.focus();
	});

	return (
		<div class="w-svw h-svh bg-cycle-secondary flex flex-col place-items-center">
			<section class="flex flex-col place-items-center gap-8 grow justify-center">
				<img
					src={blob}
					class="w-40 animate-in slide-in-from-bottom-15"
					alt="fuck"
				/>

				<OTPField
					value={pin()}
					onValueChange={setPin}
					maxLength={4}
					onComplete={verify}
				>
					<OTPFieldInput autofocus ref={setInputRef} />
					<OTPFieldGroup>
						<OTPFieldSlot
							class="slide-in-from-bottom-15 fade-in-0 duration-700"
							index={0}
						/>
						<OTPFieldSlot index={1} />
						<OTPFieldSlot index={2} />
						<OTPFieldSlot index={3} />
					</OTPFieldGroup>
				</OTPField>
			</section>

			<span class="font-semibold text-xl text-cycle-primary h-12">
				Periodt.
			</span>
		</div>
	);
};

export default DeviceGuard;
