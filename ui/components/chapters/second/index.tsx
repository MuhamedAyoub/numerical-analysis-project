import InfoSection from '@/components/common/info';
import MatrixForm from '@/components/forms/matrix';
import { Icons } from '@/components/icons';

const info = {
	title: 'Module Title 2 :',
	subtitle: 'Module Subtitle 2',
};
export default function SecondChapter() {
	return (
		<div className="p-6 flex flex-col gap-6">
			<section className="p-6 border">
				<InfoSection
					{...info}
					desc={
						<p>
							desc: lorem ipsum dolor sit amet, consectetur adipiscing elit.
							Nulla quam velit, <b> vestibulum in vel, auctor urna </b>. Lorem
							ipsum dolor,
						</p>
					}>
					<Icons.equations className="w-8 h-8" />
				</InfoSection>
			</section>
			<div className=" p-4">
				<MatrixForm />
			</div>
		</div>
	);
}
