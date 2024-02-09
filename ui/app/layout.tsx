import type { Metadata } from 'next';
import { Fira_Code } from 'next/font/google';
import './globals.css';
import Header from '@/components/header';
import Footer from '@/components/footer';
import { cn } from '@/lib/utils';

const fira = Fira_Code({
	subsets: ['latin', 'cyrillic', 'greek'],
	weight: ['300', '500', '600', '400'],
});

export const metadata: Metadata = {
	title: 'whyman',
	description: 'A collection of numerical analysis algorithms',
};

export default function RootLayout({
	children,
}: Readonly<{
	children: React.ReactNode;
}>) {
	return (
		<html lang="en">
			<body
				className={cn(
					fira.className,
					'min-h-[100vh] w-screen flex flex-col justify-between'
				)}>
				<Header />
				<main className="w-full h-full">{children}</main>
				<Footer />
			</body>
		</html>
	);
}
