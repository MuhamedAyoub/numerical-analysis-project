import InfoSection from '@/components/common/info';
import { Icons } from '@/components/icons';
import { H4, P } from '@/components/typography';

export default function About() {
	const info = {
		title: 'Who are we?',
		subtitle: 'Authors : ',
	};
	return (
		<div className="flex flex-col gap-4">
			<InfoSection
				{...info}
				desc={
					<ul>
						<li className="p-2">
							<H4 text="1- Merzouka Younes Abdelsamed " />
							<P text="Student At Esi Sba" className="indent-4" />
							<b className="pl-4">Group:2 </b>
							<H4 className="text-lg indent-4" text="Work" />
							<ol style={{ listStyle: 'inside' }} className="pl-6 p-2">
								<li>Chapter 1</li>
								<li>Chapter 3</li>
								<li>Chapter 5</li>
								<li>Chapter 6</li>
							</ol>
						</li>
						<li className="p-2">
							<H4 text="2- Ameri Mohamed Ayoub" />

							<P text="Student At Esi Sba" className="indent-4" />
							<b className="pl-4">Group:1 </b>
							<H4 className="text-lg indent-4" text="Work" />

							<ol style={{ listStyle: 'inside' }} className="pl-6 p-2">
								<li>Chapter 2</li>
								<li>Chapter 4</li>
								<li>Chapter 7</li>
								<li>The web site</li>
							</ol>
						</li>
					</ul>
				}>
				<Icons.root className="w-10 h-10" />
			</InfoSection>
		</div>
	);
}
