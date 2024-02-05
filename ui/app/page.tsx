import InfoSection from '@/components/common/info';
import { Icons } from '@/components/icons';

const info: {
	title: string;
	desc: string;
	subtitle: string;
}[] = [
	{
		title: 'Module Title :',
		desc: ' lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vestibulum in vel, auctor urna.',
		subtitle: 'Module Subtitle',
	},
	{
		desc: 'lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vestibulum in vel, auctor urna.',
		subtitle: 'About Project',
		title: 'Project Intro :',
	},
];
export default function Home() {
	return (
		<div className="flex flex-col gap-4">
			{info.map((inf, index) => (
				<InfoSection {...inf} key={index}>
					<Icons.root className="w-10 h-10" />
				</InfoSection>
			))}
		</div>
	);
}
