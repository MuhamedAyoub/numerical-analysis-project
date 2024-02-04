import { cn } from '@/lib/utils';

type Props = React.HTMLAttributes<HTMLHeadingElement> & {
	text: string;
};

export const H1: React.FC<Props> = ({ text, className, ...props }) => {
	return (
		<h1
			{...props}
			className={cn(
				'scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl',
				className
			)}>
			{text}
		</h1>
	);
};

export const H2: React.FC<Props> = ({ text, className, ...props }) => {
	return (
		<h2
			className={cn(
				'scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight first:mt-0',
				className
			)}>
			{text}
		</h2>
	);
};

export const H3: React.FC<Props> = ({ text, className, ...props }) => {
	return (
		<h3
			className={cn(
				'scroll-m-20 text-2xl font-semibold tracking-tight',
				className
			)}>
			{text}
		</h3>
	);
};

export const H4: React.FC<Props> = ({ text, className, ...props }) => {
	return (
		<h4
			className={cn(
				'scroll-m-20 text-xl font-semibold tracking-tight',
				className
			)}>
			{text}
		</h4>
	);
};

export const P: React.FC<Props> = ({ text, className, ...props }) => {
	return (
		<p className={cn('leading-7 [&:not(:first-child)]:mt-6', className)}>
			{text}
		</p>
	);
};
