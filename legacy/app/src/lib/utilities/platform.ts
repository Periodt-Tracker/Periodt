import { Capacitor } from "@capacitor/core";

export const platform = {
	web: "web",
	android: " android",
	ios: "ios",
};

export function isWeb() {
	return Capacitor.getPlatform() === platform.web;
}
