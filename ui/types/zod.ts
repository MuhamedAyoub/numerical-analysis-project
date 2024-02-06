import { z } from 'zod';
export enum Ch2Methods {
	LU = 'LU',
	Cholesky = 'Cholesky',
	Gauss = 'Gauss',
}
export const MatrixSchema = z.object({
	selected_method: z.nativeEnum(Ch2Methods).default(Ch2Methods.LU),
	rows: z.coerce.number().positive().default(2),
	columns: z.coerce.number().default(2),
	coefficient: z.array(z.array(z.coerce.number().default(0))),
	values: z.array(z.coerce.number().default(0)),
});

export type TMatrix = z.infer<typeof MatrixSchema>;
