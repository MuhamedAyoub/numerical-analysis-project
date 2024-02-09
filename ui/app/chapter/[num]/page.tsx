import FourthChapter from '@/components/chapters/fourth';
import SecondChapter from '@/components/chapters/second';
import SixthChapter from '@/components/chapters/sixth'
type Props = {
	params: {
		num: string;
	};
};
export default function ChapterPage({ params: { num } }: Props) {
	switch (num) {
		case '1':
			return <h1>Chapter 1</h1>;
		case '2':
			return <SecondChapter />;
		case '3':
			return <h1>Chapter 3</h1>;
		case '4':
			return <FourthChapter />
		case '5':
			return <h1>Chapter 5</h1>;
		case '6':
			return <SixthChapter />;
		case '7':
			return <h1>Chapter 7</h1>;

		default:
			return <h1>Chapter 1</h1>;
	}
}

export function generateStaticParams() {
	return ['1', '2', '3', '4', '5', '6', '7'];
}
