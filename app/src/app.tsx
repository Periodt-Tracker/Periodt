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
import { Navigator } from "./lib/navigation";
import BugReport from "./lib/components/bugs";

const App: Component = () => {
	const storageManager = createLocalStorageManager("vite-ui-theme");

	return (
		<I18nProvider>
			<SettingsProvider>
				<SecurityGuard>
					<PeriodProvider>
						<Suspense>
							<BugReport />

							<Navigator
								root={HomePage}
								routes={{
									settings: { component: SettingsPage },
									profile_settings: { component: ProfileSettingsPage },
									security_settings: { component: SecuritySettingsPage },
								}}
							/>
						</Suspense>
					</PeriodProvider>
				</SecurityGuard>
			</SettingsProvider>
		</I18nProvider>
	);

	// return (
	// 	<Router
	// 		root={(props) => (
	// 			<>
	// 				{/* <ColorModeScript storageType={storageManager.type} /> */}
	// 				{/**/}
	// 				{/* <ColorModeProvider storageManager={storageManager}> */}
	// 				<I18nProvider>
	// 					<SettingsProvider>
	// 						<SecurityGuard>
	// 							<PeriodProvider>
	// 								<Suspense>{props.children}</Suspense>
	// 							</PeriodProvider>
	// 						</SecurityGuard>
	// 					</SettingsProvider>
	// 				</I18nProvider>
	// 				{/* </ColorModeProvider> */}
	// 			</>
	// 		)}
	// 	>
	// 		<Route path="/" component={HomePage} />
	//
	// 		<Route path="/history" component={HistoryPage} />
	//
	// 		<Route path="/settings">
	// 			<Route path="/" component={SettingsPage} />
	// 			<Route path="/profile" component={ProfileSettingsPage} />
	// 			<Route path="/security" component={SecuritySettingsPage} />
	// 		</Route>
	//
	// 		<Route path="*404" component={FallbackPage} />
	// 	</Router>
};

export default App;
