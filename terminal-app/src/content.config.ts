import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const tutorials = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/tutorials" }),
  schema: z.object({
    title: z.string(),
    index: z.number().int().positive(),
    starterCode: z.array(z.object({
      code: z.string(),
    }))
  }),
});

export const collections = { tutorials };
