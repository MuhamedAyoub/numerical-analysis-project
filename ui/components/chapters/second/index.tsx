import InfoSection from '@/components/common/info';
import MatrixForm from '@/components/forms/matrix';
import { Icons } from '@/components/icons';

const info = {
	title: 'Algorithms for Solving Systems :',
	subtitle: 'Overview',
};
export default function SecondChapter() {
	return (
		<div className="p-6 flex flex-col gap-6">
			<section className="p-6 border">
				<InfoSection
					{...info}
					desc={
						<>
						<p>
						This document describes R functions that implement several algorithms for solving systems of linear equations with 10 variables. The included algorithms are:
						</p>
<ul style={{listStyle:"inside"}}>
<li className='font-bold'>

Gaussian Elimination with Total Pivoting
</li>

<li className='font-bold'>

Gaussian Elimination with Partial Pivoting
</li>
<li className='font-bold'>

LU Decomposition
</li>
<li className='font-bold'>
Cholesky Decomposition
</li>

</ul>

						<b>
						Additional Information
						</b>
						<p>
Each function includes input validation to ensure correct matrix dimensions and properties.
The controller function allows for choosing the desired solution method.</p>
						</>
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
