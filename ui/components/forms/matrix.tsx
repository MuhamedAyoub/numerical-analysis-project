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

export default function MatrixForm() {
	const form = useForm<TMatrix>({
		defaultValues: {
			rows: 2,
			columns: 2,
			data: [
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
	const currentRow = form.watch('rows');
	const currentColumn = form.watch('columns');
	matrix = new Array(currentRow).fill(new Array(currentColumn).fill(0));
	return (
		<Form {...form}>
			<form onSubmit={form.handleSubmit(submitHandler)}>
				<div className="flex gap-4">
					<FormField
						control={form.control}
						name="rows"
						render={({ field }) => (
							<FormItem>
								<FormLabel>Question announcement: </FormLabel>
								<FormControl>
									<Input {...field} type="number" min={2} max={10} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
					<FormField
						control={form.control}
						name="rows"
						render={({ field }) => (
							<FormItem>
								<FormLabel>Question announcement: </FormLabel>
								<FormControl>
									<Input {...field} type="number" min={2} max={10} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
				</div>
				<div className="flex flex-col gap-1">
					{matrix.map((row, i) => (
						<div className="flex gap-1" key={i}>
							{row.map((col, j) => (
								<FormField
									key={j}
									control={form.control}
									name={`data.${i}.${j}`}
									render={({ field }) => (
										<FormItem key={j}>
											<FormControl>
												<Input {...field} />
											</FormControl>
											<FormMessage />
										</FormItem>
									)}
								/>
							))}
						</div>
					))}
				</div>
				{}
			</form>
		</Form>
	);
}
