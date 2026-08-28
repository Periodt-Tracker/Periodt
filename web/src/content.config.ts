import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const blog = defineCollection({
	loader: glob({ base: "./src/content/blog", pattern: "**/*.{md,mdx}" }),
	schema: ({ image }) =>
		z.object({
			title: z.string(),
			description: z.string(),
			date: z.coerce.date().optional(),
			category: z.string(),
			updated_date: z.coerce.date().optional(),
			image: image().optional(),
		}),
});

export const collections = { blog };
