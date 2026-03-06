import { createLocalStorageManager } from "@kobalte/core";
import { Route, Router } from "@solidjs/router";
import { type Component, Suspense } from "solid-js";
import SettingsProvider from "@/lib/settings/settings-provider";

import HomePage from "./routes";
import HistoryPage from "./routes/history";
import PeriodProvider from "./lib/cycle/cycle-provider";
import SettingsPage from "./routes/settings";
import SecurityGuard from "./lib/components/security";
import FallbackPage from "./routes/[...404]";
import ProfileSettingsPage from "./routes/settings/profile";
import SecuritySettingsPage from "./routes/settings/security";
import I18nProvider from "./lib/i18n/i18n-provider";
import { Navigator, NavigatorPage } from "./lib/navigation";
import BugReport from "./lib/components/bugs";
import SymptomsSettingsPage from "./routes/settings/symptoms";

import { LocalNotifications } from "@capacitor/local-notifications";
import Navbar from "./lib/components/navbar";

const App: Component = () => {
	const storageManager = createLocalStorageManager("vite-ui-theme");

	async function scheduleDailyNotification() {
		await LocalNotifications.requestPermissions();

		const now = new Date();
		const notificationTime = new Date();

		notificationTime.setSeconds(notificationTime.getSeconds() + 30);

		await LocalNotifications.schedule({
			notifications: [
				{
					title: "Aaaaaaaaaaaaaaaaaaaa",
					body: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
					id: 1,
					schedule: {
						// repeat daily
						at: notificationTime,
						repeats: true,
					},
					actionTypeId: "",
					extra: null,
				},
			],
		});

		alert("Done!");
	}

	// scheduleDailyNotification();

	return (
		<I18nProvider>
			<SettingsProvider>
				<SecurityGuard>
					<PeriodProvider>
						<Suspense>
							<BugReport />

							<Navigator
								intialPage="home"
								layout={(props) => (
									<section>
										{props.children}

										<Navbar />
									</section>
								)}
								fallback={<FallbackPage />}
							>
								<NavigatorPage name="home" component={HomePage} />

								<NavigatorPage name="history" component={HistoryPage} />
							</Navigator>
						</Suspense>
					</PeriodProvider>
				</SecurityGuard>
			</SettingsProvider>
		</I18nProvider>
	);
};

export default App;
