import { createLocalStorageManager } from "@kobalte/core";
import { Route, Router } from "@solidjs/router";
import { type Component, Suspense } from "solid-js";
import SettingsProvider from "@/lib/settings/settings-provider";

import HomePage from "./routes";
import SetupPage from "./routes/setup";

const App: Component = () => {
	const storageManager = createLocalStorageManager("vite-ui-theme");

	return (
		<Router
			root={(props) => (
				<>
					{/* <ColorModeScript storageType={storageManager.type} /> */}
					{/**/}
					{/* <ColorModeProvider storageManager={storageManager}> */}
					<SettingsProvider>
						<Suspense>{props.children}</Suspense>
					</SettingsProvider>
					{/* </ColorModeProvider> */}
				</>
			)}
		>
			<Route path="/" component={HomePage} />
			<Route path="/setup" component={SetupPage}></Route>
		</Router>
	);
};

export default App;
