import z from "zod";

export const RangeSchema = z
	.object({
		lower: z.number(),
		upper: z.number(),
	})
	.transform((range) => {
		if (range.lower > range.upper) {
			return { upper: range.lower, lower: range.upper };
		}

		return range;
	});

export const TrackedSymptomsSchema = z.object({
	bleeding: z.boolean().default(true),
	discharge: z.boolean().default(true),
	mood: z.boolean().default(true),
	sensations: z.boolean().default(true),
	digestion: z.boolean().default(true),
	energy_and_sleep: z.boolean().default(false),
	skin_and_hair: z.boolean().default(false),
	sex: z.boolean().default(false),
});

export const NotificationSettingsSchema = z.object({
	enabled: z.boolean().default(false),
});

const default_tracked_symptoms = TrackedSymptomsSchema.parse({});

export const ShakeToReportSchema = z
	.union([z.literal("ask"), z.literal("active"), z.literal("disabled")])
	.default("ask");

export const SecurityMethodSchema = z
	.union([z.literal("device"), z.literal("pin"), z.literal("none")])
	.default("pin");

export const PeriodtSettingsSchema = z.object({
	version: z.number().default(1),

	// weather the user has completed the initial setup
	// form, use this to decide if it needs to be shown
	// again.
	//
	// this can be set to false to re-trigger the setup
	// form to be taken
	//
	setup_complete: z.boolean().default(false),

	// the user's inputed name
	//
	name: z.string().default("anonymous"),

	// the security method to
	security: z
		.union([z.literal("device"), z.literal("pin"), z.literal("none")])
		.default("pin"),
	blank_screen: z.boolean().default(false),
	lock_on_resume: z.boolean().default(false),
	show_fertility: z.boolean().default(false),
	period_length: RangeSchema.default({ lower: 4, upper: 6 }),
	cycle_length: RangeSchema.default({ lower: 26, upper: 28 }),
	tracked_symptoms: TrackedSymptomsSchema.default(default_tracked_symptoms),

	// wether shake to report bugs is enabled
	//
	// by default ask if the user wants to leave this
	// active the first time they do it to improve
	// discoverability while clear that is optional
	//
	shake_to_report: z
		.union([z.literal("ask"), z.literal("active"), z.literal("disabled")])
		.default("ask"),

	use_health_data: z
		.union([z.literal("ask"), z.literal("active"), z.literal("disabled")])
		.default("ask"),

	daily_reminder: z.boolean().default(false),

	open_log_on_launch: z.boolean().default(true),

	// when to send daily log reminder
	//
	// this is also used as the triggeer time for the
	// `open_log_on_launch` setting.
	//
	// accepts times up to the nearest minute
	//
	remind_at: z.iso.time({ precision: -1 }).default("19:00"),

	haptics: z.boolean().default(true),
});

export type PeriodtSettings = z.infer<typeof PeriodtSettingsSchema>;

export const default_settings = PeriodtSettingsSchema.parse({});
