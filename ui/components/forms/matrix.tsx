'use client';
import { TMatrix } from '@/types/zod';
import { useForm } from 'react-hook-form';
import {
	Form,
	FormControl,
	FormField,
	FormItem,
	FormLabel,
	FormMessage,
} from '../ui/form';
import { Input } from '../ui/input';
import { Button } from '../ui/button';

export default function MatrixForm() {
	const form = useForm<TMatrix>({
		defaultValues: {
			rows: 2,
			columns: 2,
			coefficient: [
				[0, 0],
				[0, 0],
			],
		},
	});

	const submitHandler = (data: TMatrix) => {
		console.log(data);
	};
	// declare matrix type number
	let matrix: number[][] = [[]];
	const currentRow = form.getValues('rows');
	const currentColumn = form.watch('columns');
	return (
		<Form {...form}>
			<form
				onSubmit={form.handleSubmit(submitHandler)}
				className="max-w-[789px] overflow-hidden flex flex-col gap-6">
				<div className="flex gap-4">
					<FormField
						control={form.control}
						name="rows"
						render={({ field }) => (
							<FormItem>
								<FormLabel>Rows: </FormLabel>
								<FormControl>
									<Input {...field} type="number" min={2} max={10} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
					<FormField
						control={form.control}
						name="columns"
						render={({ field }) => (
							<FormItem>
								<FormLabel>Cols: </FormLabel>
								<FormControl>
									<Input {...field} type="number" min={2} max={10} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
				</div>
				<div className="flex gap-2">
					<div className="flex flex-col gap-2">
						{Array.from({ length: currentRow }, (_, i) => (
							<div className="flex gap-1" key={i}>
								{Array.from({ length: currentColumn }, (_, j) => (
									<FormField
										key={j}
										control={form.control}
										name={`coefficient.${i}.${j}`}
										render={({ field }) => (
											<FormItem key={j}>
												<FormControl>
													<div className="flex gap-1 items-center">
														{j !== 0 && '+'}
														<Input
															{...field}
															className="w-12 h-8"
															value={field.value ?? '0'}
														/>
														*X<sub>{j + 1}</sub>
													</div>
												</FormControl>
												<FormMessage />
											</FormItem>
										)}
									/>
								))}
							</div>
						))}
					</div>
					<div className="flex flex-col gap-2">
						{Array.from({ length: currentRow }, (_, i) => (
							<FormField
								key={`b-${i}`}
								control={form.control}
								name={`values.${i}`}
								render={({ field }) => (
									<FormItem>
										<FormControl>
											<div className="flex items-center gap-2">
												={' '}
												<Input
													{...field}
													className="w-16 h-8"
													value={field.value ?? '0'}
												/>
											</div>
										</FormControl>
										<FormMessage />
									</FormItem>
								)}
							/>
						))}
					</div>
				</div>
				<Button type="submit" className="w-fit py-2 px-4 self-end">
					Solve
				</Button>
			</form>
		</Form>
	);
}
