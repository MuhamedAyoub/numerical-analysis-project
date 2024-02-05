import { z } from 'zod';
export const MatrixSchema = z.object({
	rows: z.number(),
	columns: z.number(),
	coefficient: z.array(z.array(z.number())),
	values: z.array(z.number()),
});

export type TMatrix = z.infer<typeof MatrixSchema>;
