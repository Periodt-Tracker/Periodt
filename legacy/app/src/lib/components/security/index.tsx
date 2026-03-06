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
import PinSetup from "./pin-setup";
import { Capacitor } from "@capacitor/core";
import { isWeb, platform } from "@/lib/utilities/platform";

const SecurityGuard: ParentComponent = (props) => {
	const context = useSettings();

	const securityMethod = () => context.settings.security;

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
		// enabling the privacy screen on the web doesn't break
		// anything per say but does bloat the console with
		// warnings so we'll skip just in case
		//
		if (Capacitor.getPlatform() === platform.web) {
			return;
		}

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
		<>
			<PinSetup />

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
		</>
	);
};

export default SecurityGuard;
