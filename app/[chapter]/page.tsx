import { GetStaticProps } from 'next';

type Props = {
	chapter: string;
};
export default function ChapterPage({ chapter }: Props) {
	switch (chapter) {
		case '1':
			return <h1>Chapter 1</h1>;
		case '2':
			return <h1>Chapter 2</h1>;
		case '3':
			return <h1>Chapter 3</h1>;
		case '4':
			return <h1>Chapter 4</h1>;
		case '5':
			return <h1>Chapter 5</h1>;
		case '6':
			return <h1>Chapter 6</h1>;
		case '7':
			return <h1>Chapter 7</h1>;

		default:
			return <h1>Chapter 1</h1>;
	}
}
