import { Logger } from "@aparajita/capacitor-logger";

export const logger = new Logger("periodt.", {
	labels: {
		error: "[error]",
		warn: "[warn]",
		info: "[info]",
		debug: "[debug]",
	},
});
