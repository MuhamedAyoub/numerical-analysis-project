'use client';
import { Icons } from '@/components/icons';
import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { useRef, useState } from 'react';

enum ELoading {
	DEFAULT = 'DEFAULT',
	LOADING = 'LOADING',
	SUCCESS = 'SUCCESS',
	READY = 'READY',
	ERROR = 'ERROR',
}

export default function FourthChapter() {
	const canvasRef = useRef<HTMLCanvasElement>(null);
	const [loading, setLoading] = useState<ELoading>(ELoading.DEFAULT);
	const [currentImage, setCurrentImage] = useState<HTMLImageElement | null>(
		null
	);
	const [href, setHref] = useState<string>('');
	const uploadHandler = (e: React.ChangeEvent<HTMLInputElement>) => {
		const file = e.target.files?.[0];
		if (file) {
			const reader = new FileReader();
			reader.onload = (e) => {
				const img = new Image();
				img.src = e.target?.result as string;
				setCurrentImage(img);
			};
			reader.readAsDataURL(file);
		}
	};

	const renderCount = useRef(0).current++;
	console.log('renderCount', renderCount);
	const confirmHandler = () => {
		console.log('confirmHandler');
		setLoading(ELoading.LOADING);
		const canvas = canvasRef.current;
		const ctx = canvas?.getContext('2d');
		ctx?.drawImage(currentImage as HTMLImageElement, 0, 0);
		const matrix = ctx?.getImageData(
			0,
			0,
			currentImage?.width!,
			currentImage?.height!
		);
		console.log(matrix?.data);
		setLoading(ELoading.SUCCESS);
		// Draw image from the matrix
		setTimeout(() => {
			ctx?.putImageData(matrix as ImageData, 0, 0);
			setLoading(ELoading.SUCCESS);
			// now make the image downloadable
			const href2 = canvas?.toDataURL('image/png');
			setHref(href2 as string);
		}, 3000);
	};

	return (
		<div className="p-6 flex justify-center items-center">
			{loading === ELoading.DEFAULT && (
				<div className="flex flex-col gap-8">
					<Button className=" relative p-2 w-48 cursor-pointer">
						Upload Image
						<input
							type="file"
							className="w-full h-full absolute top-0 left-0 opacity-0"
							onChange={uploadHandler}
						/>
					</Button>
					<Button
						className="p-2 w-48"
						disabled={currentImage == null}
						onClick={confirmHandler}>
						Confirm
					</Button>
				</div>
			)}

			{loading === ELoading.READY && (
				<Button className="bg-green-500">COMPRESS IMAGE</Button>
			)}
			{loading === ELoading.LOADING && (
				<Button className="w-48" disabled={true} type="submit">
					<Icons.spinner className="mr-2 h-4 w-4 animate-spin" />
					Processing ...
				</Button>
			)}

			<canvas ref={canvasRef} id="canvas" className={'hidden'} />

			{loading == ELoading.SUCCESS && (
				<Link href={href} target="_blank" download={href}>
					<Button>Get image</Button>
				</Link>
			)}
		</div>
	);
}
