import Link from 'next/link';

export default function Footer() {
	return (
		<footer className="h-40 p-6 flex items-center justify-center">
			<ul className=" w-2/3  grid grid-cols-2 gap-5">
				<li className="hover:underline">
					<Link href="/">Home</Link>
				</li>
				<li className="hover:underline">
					<Link href="/about">About</Link>
				</li>
				<li className="hover:underline">
					<Link href="/">Team</Link>
				</li>
				<li className="hover:underline">
					<Link href="/">Source code</Link>
				</li>
			</ul>
		</footer>
	);
}
