import type { CapacitorConfig } from "@capacitor/cli";

const isDebug = process.env.NODE_ENV === "development";
const serverUrl = process.env.CAPACITOR_SERVER_URL;

const config: CapacitorConfig = {
	appId: "com.periodt.app",
	appName: "Periodt.",
	webDir: "dist",
	server: {
		androidScheme: "https",
	},
};

if (isDebug && !serverUrl) {
	console.warn("Debug was enabled but not server url was given");
}

if (isDebug && serverUrl) {
	console.info(`Building with live reloading enabled from ${serverUrl}`);

	config.server = {
		androidScheme: "https",
		url: serverUrl,
		cleartext: true,
	};
}

export default config;
