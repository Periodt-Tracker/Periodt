export const dict = {
	title: "Periodt.",
	setup: {
		welcome: "Welcome to periodt!",
		start: "Get Started",
	},
	phase: {
		period: {
			name: "Period",
			description:
				"Your body is shedding last month’s lining and starting fresh. Hormone levels are low, which can mean lower energy and a stronger need for rest. This isn’t a setback—it’s the baseline before the next rise.",
			current: "Current phase: Period",
		},
		follicular: {
			name: "Follicular",
			description:
				"Estrogen begins to rise as your body prepares an egg for release. Energy and focus often return, and learning or planning feels easier. This is your internal green light to explore and experiment.",
			current: "Current phase: Follicular",
		},
		ovulation: {
			name: "Ovulation",
			description:
				"An egg is released, and estrogen peaks. Many people feel more confident, social, and clear-headed now. This phase evolved for connection and communication—your glow is biology doing its thing.",
			current: "Current phase: Ovulation",
		},
		luteal: {
			name: "Luteal",
			description:
				"Progesterone rises to support a potential pregnancy. If one doesn’t happen, energy may dip and emotions can feel closer to the surface. This phase highlights what’s out of balance—your body asking for care, comfort, and honesty.",
			current: "Current phase: Luteal",
		},
		period_picker: {
			title: "Add a period",
		},
	},
	home: {
		welcome: (name: string) => `Hi ${name}`,
		period_day: (day: number) => `Period Day ${day}`,
		period_in: (day: number) => `Period in ${day} days`,
	},
	symptoms: {
		bleeding: "Bleeding",
		dischardge: "Discharge",
		mood: "Sensations",
		digestion: "Digestion",
		energy_and_sleep: "Energy & Sleep",
		skin_and_hair: "Skin & Hair",
		sex: "Sex",
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
		symptoms: {
			title: "Symptoms",
			description: "Manage tracked symptoms",
		},
	},
	fallback: {
		title: "That shouldn't have happened",
		description:
			"You found a missing page, please send us a message explaining how you got here",
		return: "Back",
	},
};
