'use client';
import { Ch2Methods, MatrixSchema, TMatrix } from '@/types/zod';
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
import { zodResolver } from '@hookform/resolvers/zod';
import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
	SelectValue,
} from '../ui/select';
import { systemSolverApi } from '@/actions/forms';
import { Icons } from '../icons';
import { H4, P } from '../typography';
import { useState } from 'react';

export default function MatrixForm() {
	const form = useForm<TMatrix>({
		resolver: zodResolver(MatrixSchema),
		defaultValues: {
			rows: 2,
			columns: 2,
			coefficient: [
				[0, 0],
				[0, 0],
			],
		},
	});
	const loading = form.formState.isSubmitting;
	const submitHandler = async (data: TMatrix) => {
		console.log(data);
		try {
			const response = await systemSolverApi(data);
			console.log(response);
			if (response.status[0] === 'success') {
				setSolution({
					execution_time: response.execution_time,
					x: response.x,
				});
			}
		} catch (e) {
			console.log(e);
		}
	};
	// declare matrix type number
	const currentRow = form.getValues('rows');
	const currentColumn = form.watch('columns');
	const [solution, setSolution] = useState<{
		execution_time: number;
		x: number[];
	} | null>(null);
	return (
		<Form {...form}>
			<form
				onSubmit={form.handleSubmit(submitHandler)}
				className="max-w-[789px] overflow-hidden flex flex-col gap-6">
				<FormField
					name="selected_method"
					control={form.control}
					render={({ field }) => (
						<FormItem className="w-52">
							<Select onValueChange={field.onChange} defaultValue={field.value}>
								<FormControl>
									<SelectTrigger>
										<SelectValue placeholder="Select a Method" />
									</SelectTrigger>
								</FormControl>
								<SelectContent>
									<SelectItem value={Ch2Methods.LU}>{Ch2Methods.LU}</SelectItem>
									<SelectItem value={Ch2Methods.Cholesky}>
										{Ch2Methods.Cholesky}
									</SelectItem>
									<SelectItem value={Ch2Methods.Gauss}>
										{Ch2Methods.Gauss}
									</SelectItem>
								</SelectContent>
							</Select>
							<FormMessage />
						</FormItem>
					)}
				/>
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
															className="w-16 h-8"
															type="number"
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
													type="number"
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
				<Button
					type="submit"
					className="w-fit py-2 px-4 self-end"
					disabled={loading}>
					Solve{' '}
					{loading && <Icons.spinner className="mr-2 h-4 w-4 animate-spin" />}
				</Button>
			</form>
			{solution && (
				<div className="flex flex-col gap-4">
					<H4 text="Solution" />
					<P text={'Execution Time : ' + solution.execution_time} />
					<ul className="flex  flex-col gap-1" style={{ listStyle: 'inside' }}>
						{solution.x.map((v, i) => (
							<li key={i} className="flex gap-1">
								{' '}
								<span>
									X<sub>{i + 1}</sub>=
								</span>{' '}
								{v}{' '}
							</li>
						))}
					</ul>
				</div>
			)}
		</Form>
	);
}
