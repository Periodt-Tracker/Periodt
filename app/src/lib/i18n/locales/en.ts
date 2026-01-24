export const dict = {
	title: "Periodt.",
	setup: {
		welcome: "Welcome to periodt!",
		start: "Get Started",
	},
	home: {
		welcome: (name: string) => `Hi ${name}`,
		phase: {
			period: "Period",
			follicular: "Follicular",
			ovulation: "Ovulation",
			luteal: "Luteal",
		},
		period_day: (day: number) => `Period Day ${day}`,
		period_in: (day: number) => `Period in ${day} days`,
	},
	settings: {
		locale: {
			select: "Select your language",
			confirm: "Select",
			en: "English",
			pl: "Polish",
		},
		title: "Settings",
		profile: {
			title: "My Profile",
			description: "Name, Language",
		},
		accessibility: {
			title: "Accessibility",
			description: "Haptics, Screen Reader",
		},
		security: {
			title: "Security & Privacy",
			description: "App Lock, Privacy Screen",
			device: {
				title: "Device",
				description:
					"Require your phone's fingerprint, Face ID, password etc...",
			},
			pin: {
				title: "Pin",
				description: "Set a custom pin different to your device login",
			},
			none: {
				title: "None",
				description: "No lock for periodt.",
			},
			blank_screen: {
				title: "Blank Screen",
				description: "Hide the content of periodt. from the app switcher",
			},
			lock_on_resume: {
				title: "Lock on Resume",
				description:
					"Lock periodt. whenever you come back even if you don't close it",
			},
		},
	},
	fallback: {
		title: "That shouldn't have happened",
		description:
			"You found a missing page, please send us a message explaining how you got here",
		return: "Back",
	},
};
