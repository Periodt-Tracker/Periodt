import type { DischargeColourRules } from "./types";

export const mood = {
	happy: "happy",
	excited: "excited",
	neutral: "neutral",
	irritable: "irritable",
	angry: "angry",
	anxious: "anxious",
	sad: "sad",
	stressed: " stressed",
} as const;

export const discharge_colour = {
	bloody: "bloody",
	clear: "clear",
	green: "green",
	grey: "grey",
	white: "white",
	yellow: "yellow",
	none: "none",
	not_sure: "not_sure",
} as const;

export const discharge_consistency = {
	purulent: "purulent",
	thick: "thick",
	slippery: "slippery",
	pus_like: "pus_like",
	thin: "thin",
	curdy: "curdy",
	frothy: "frothy",
	not_sure: "not_sure",
} as const;

export const discharge_odor = {
	foul: "foul",
	fishy: "fishy",
	mushroom: "mushroom",
	none: "none",
	not_sure: "not_sure",
} as const;

export const conditions = {
	bactertial_vaginosis: {
		links: {
			uk: [
				{
					provider: "nhs",
					url: "https://www.nhs.uk/conditions/bacterial-vaginosis/",
				},
			],
		},
	},
	candidiasis: {
		links: {
			uk: [
				{
					provider: "nhs",
					url: "https://www.nhs.uk/conditions/thrush-in-men-and-women/",
				},
			],
		},
	},
	trichomoniasis: {
		links: {
			uk: [
				{
					provider: "nhs",
					url: "https://www.nhs.uk/conditions/trichomoniasis/",
				},
			],
			us: [
				{
					provider: "mayo",
					url: "https://www.mayoclinic.org/diseases-conditions/trichomoniasis/symptoms-causes/syc-20378609",
				},
			],
		},
	},
	desquamative_inflammatory_vaginitis: {
		links: {
			us: {
				provider: "cleveland_clinic",
				url: "https://my.clevelandclinic.org/health/diseases/24319-desquamative-inflammatory-vaginitis",
			},
		},
	},
	foreign_object_retained: {
		links: {},
	},
	gonorrhoea: {
		links: {
			uk: {
				provider: "nhs",
				url: "https://www.nhs.uk/conditions/gonorrhoea/",
			},
		},
	},
} as const;

export const discharge_rules: DischargeColourRules = {
	// bloody discharge is always concerning no matter
	// what flag all combinations of consistency and
	// odor here
	[discharge_colour.bloody]: {
		[discharge_consistency.purulent]: {
			[discharge_odor.foul]: {
				risks: [
					conditions.foreign_object_retained,
					conditions.desquamative_inflammatory_vaginitis,
				],
			},
			[discharge_odor.none]: {
				risks: [conditions.desquamative_inflammatory_vaginitis],
			},
			[discharge_odor.not_sure]: {
				risks: [
					conditions.foreign_object_retained,
					conditions.desquamative_inflammatory_vaginitis,
				],
			},
		},
		[discharge_consistency.not_sure]: {
			[discharge_odor.foul]: {
				risks: [
					conditions.foreign_object_retained,
					conditions.desquamative_inflammatory_vaginitis,
				],
			},
			[discharge_odor.none]: {
				risks: [conditions.desquamative_inflammatory_vaginitis],
			},
			[discharge_odor.not_sure]: {
				risks: [
					conditions.foreign_object_retained,
					conditions.desquamative_inflammatory_vaginitis,
				],
			},
		},
	},
	[discharge_colour.clear]: {
		[discharge_consistency.thick]: {},
		[discharge_consistency.slippery]: {},
		[discharge_consistency.not_sure]: {},
	},
	[discharge_colour.green]: {
		[discharge_consistency.frothy]: {
			[discharge_odor.fishy]: {
				risks: [conditions.trichomoniasis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.trichomoniasis],
			},
		},
		[discharge_consistency.pus_like]: {
			[discharge_odor.fishy]: {
				risks: [conditions.gonorrhoea],
			},
			[discharge_odor.mushroom]: {
				risks: [conditions.gonorrhoea],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.gonorrhoea],
			},
		},
		[discharge_consistency.not_sure]: {
			[discharge_odor.fishy]: {
				risks: [conditions.gonorrhoea, conditions.trichomoniasis],
			},
			[discharge_odor.mushroom]: {
				risks: [conditions.gonorrhoea, conditions.trichomoniasis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.gonorrhoea, conditions.trichomoniasis],
			},
		},
	},
	grey: {
		[discharge_consistency.thin]: {
			[discharge_odor.fishy]: {
				risks: [conditions.bactertial_vaginosis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.bactertial_vaginosis],
			},
		},
		[discharge_consistency.not_sure]: {
			[discharge_odor.fishy]: {
				risks: [conditions.bactertial_vaginosis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.bactertial_vaginosis],
			},
		},
	},
	[discharge_colour.white]: {
		[discharge_consistency.thick]: {},
		[discharge_consistency.slippery]: {},
		[discharge_consistency.thin]: {
			[discharge_odor.fishy]: {
				risks: [conditions.bactertial_vaginosis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.bactertial_vaginosis],
			},
		},
		[discharge_consistency.curdy]: {
			[discharge_odor.none]: {
				risks: [conditions.candidiasis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.candidiasis],
			},
		},
		[discharge_consistency.not_sure]: {
			[discharge_odor.none]: {},
			[discharge_odor.fishy]: {
				risks: [conditions.bactertial_vaginosis],
			},
			[discharge_odor.not_sure]: {},
		},
	},
	[discharge_colour.yellow]: {
		[discharge_consistency.frothy]: {
			[discharge_odor.fishy]: {
				risks: [conditions.trichomoniasis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.trichomoniasis],
			},
		},
		[discharge_consistency.purulent]: {
			[discharge_odor.foul]: {
				risks: [conditions.desquamative_inflammatory_vaginitis],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.desquamative_inflammatory_vaginitis],
			},
		},
		[discharge_consistency.pus_like]: {
			[discharge_odor.fishy]: {
				risks: [conditions.gonorrhoea],
			},
			[discharge_odor.mushroom]: {
				risks: [conditions.gonorrhoea],
			},
			[discharge_odor.not_sure]: {
				risks: [conditions.gonorrhoea],
			},
		},
	},
	[discharge_colour.not_sure]: {},
	[discharge_colour.none]: {},
};
