import { H2, H4, P } from '@/components/typography/heading';
import { Separator } from '@radix-ui/react-separator';

type Props = {
	title: string;
	subtitle: string;
	desc: string;
};
export default function InfoSection({ desc, subtitle, title }: Props) {
	return (
		<section className="flex p-6 flex-col gap-4">
			<H2 text={title} />
			<Separator />

			<div className="p-4 w-full flex flex-col gap-2">
				<H4 text={subtitle} />
				<P text={desc} className="text-sm" />
			</div>
		</section>
	);
}
