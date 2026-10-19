import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const schema = z.object({
	title: z.string(),
	date: z.coerce.date(),
	description: z.string().optional(),
	draft: z.boolean().default(false),
});

const blog = defineCollection({
	loader: glob({ pattern: '**/*.md', base: './src/content/blog' }),
	schema,
});

const poetry = defineCollection({
	loader: glob({ pattern: '**/*.md', base: './src/content/poetry' }),
	schema,
});

export const collections = { blog, poetry };
