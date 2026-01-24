import { useSettings } from "@/lib/settings";
import {
	createEffect,
	createSignal,
	Match,
	onCleanup,
	Show,
	Switch,
	type ParentComponent,
} from "solid-js";
import { security_type } from "./constants";
import DeviceGuard from "./device-guard";
import { App } from "@capacitor/app";
import PinGuard from "./pin-guard";

import { PrivacyScreen } from "@capacitor/privacy-screen";

const SecurityGuard: ParentComponent = (props) => {
	const context = useSettings();

	const securityMethod = () => context.settings.securtiy ?? "none";

	const isNone = () => securityMethod() === security_type.none;

	const [verified, setVerified] = createSignal(isNone());

	createEffect(async () => {
		if (!context.settings.lock_on_resume) {
			return;
		}

		const handle = await App.addListener("appStateChange", (event) => {
			if (!event.isActive) {
				setVerified(false);
			}
		});

		onCleanup(async () => await handle.remove());
	});

	createEffect(async () => {
		if (!context.settings.blank_screen) {
			return;
		}

		await PrivacyScreen.enable({
			android: {
				dimBackground: false,
			},
			ios: {
				blurEffect: "dark",
			},
		});

		onCleanup(async () => await PrivacyScreen.disable());
	});

	return (
		<Show when={!verified()} fallback={props.children}>
			<Switch>
				<Match when={securityMethod() === security_type.device}>
					<DeviceGuard onVerified={() => setVerified(true)} />
				</Match>

				<Match when={securityMethod() === security_type.pin}>
					<PinGuard onVerified={() => setVerified(true)} />
				</Match>
			</Switch>
		</Show>
	);
};

export default SecurityGuard;
