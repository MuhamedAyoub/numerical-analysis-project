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

export enum Ch4Methods {
	POWER_ITERATION = 'POWER_ITERATION',
	DEFLATION_METHOD = 'DEFLATION_METHOD',
	GIVENS_ROTATION = 'GIVENS_ROTATION',
}

export type TCh4Body = {
	selected_method: Ch4Methods;
	mat: Uint8ClampedArray
	width: number;
	height: number;
}

export type TMatrix = z.infer<typeof MatrixSchema>;


