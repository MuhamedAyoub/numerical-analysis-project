import { z } from 'zod';
export const MatrixSchema = z.object({
	rows: z.number(),
	columns: z.number(),
	data: z.array(z.array(z.number())),
});

export type TMatrix = z.infer<typeof MatrixSchema>;
