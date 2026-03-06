import { MetaProvider, Title } from "@solidjs/meta";
import { Route, Router } from "@solidjs/router";

import { type Component, Suspense } from "solid-js";
import LandingPage from "./routes";

const App: Component = () => {
	return (
		<Router
			root={(props) => (
				<MetaProvider>
					<Title>Periodt.</Title>

					<Suspense>{props.children}</Suspense>
				</MetaProvider>
			)}
		>
			<Route path="/" component={LandingPage} />
		</Router>
	);
};

export default App;
