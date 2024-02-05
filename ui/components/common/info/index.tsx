import { H2, H4, P } from '@/components/typography';
import { Separator } from '@/components/ui/separator';
import { PropsWithChildren } from 'react';

type Props = PropsWithChildren & {
	title: string;
	subtitle: string;
	desc: string;
};
export default function InfoSection({
	desc,
	subtitle,
	title,
	children,
}: Props) {
	return (
		<section className="flex p-6 flex-col gap-4">
			<div className="flex gap-3 items-center ">
				<H2 text={title} />
				{children}
			</div>
			<Separator className="bg-gray-300" />
			<div className="p-4 w-full flex flex-col gap-2 border border-gray-600">
				<H4 text={subtitle} />
				<P text={desc} className="text-sm" />
			</div>
		</section>
	);
}
