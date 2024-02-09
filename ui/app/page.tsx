import InfoSection from '@/components/common/info';
import { Icons } from '@/components/icons';
import { H4 } from '@/components/typography';

const info: {
	title: string;
	subtitle: string;
} = {
	title: 'Numerical Analysis Project',

	subtitle: 'Overview',
};
const chaptersOverview = [
	{
		title: 'Chapter 1',
		desc: 'This is Chapter 1',
	},
	{
		title: 'Chapter 2',
		desc: 'This is chapter 2',
	},
	{
		title: 'Chapter 3',
		desc: 'This is chapter 3',
	},
	{
		title: 'Chapter 4',
		desc: 'This is chapter 4',
	},
	{
		title: 'Chapter 5',
		desc: 'This is chapter 5',
	},
	{
		title: 'Chapter 6',
		desc: 'This is chapter 6',
	},
	{
		title: 'Chapter 7',
		desc: 'This is chapter 7',
	},
];
export default function Home() {
	return (
		<div className="flex flex-col gap-4">
			<InfoSection
				{...info}
				desc={
					<ul>
						{chaptersOverview.map((m, i) => (
							<li key={i}>
								<H4 text={m.title} />
								<p>{m.desc} </p>
							</li>
						))}
					</ul>
				}>
				<Icons.root className="w-10 h-10" />
			</InfoSection>
		</div>
	);
}
