'use client';
import { imageCompressorApi } from '@/actions/forms';
import { Icons } from '@/components/icons';
import { Button } from '@/components/ui/button';
import { Ch4Methods } from '@/types/zod';
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

	const confirmHandler = async () => {
		setLoading(ELoading.LOADING);
		const canvas = canvasRef.current!;
		const ctx = canvas?.getContext('2d')!;
		ctx?.drawImage(currentImage as HTMLImageElement, 0, 0);
		const originalImageWidth = currentImage?.width!;
		const originalImageHeight = currentImage?.height!;
		const matrix = ctx?.getImageData(0, 0, originalImageWidth, originalImageHeight);
	
		if (!matrix) {
			console.error("Failed to get image data");
			setLoading(ELoading.ERROR);
			return;
		}
	
		// Compress the image
		const response = await imageCompressorApi({
			mat: matrix.data,
			height: originalImageHeight,
			width: originalImageWidth,
			selected_method: Ch4Methods.GIVENS_ROTATION
		});
	
		if (!response || !response.img_matrix) {
			console.error("Failed to compress image");
			setLoading(ELoading.ERROR);
			return;
		}
	
		// Ensure that the compressed image data length matches the expected size
		const expectedDataLength = originalImageWidth * originalImageHeight * 4;
		if (response.img_matrix.length !== expectedDataLength) {
			console.error("Compressed image data length doesn't match the expected size");
			setLoading(ELoading.ERROR);
			return;
		}
	
		// Create a new Uint8ClampedArray from the compressed image data
		const arr = new Uint8ClampedArray(response.img_matrix);
	
		// Create a new ImageData object with the original width and height
		const imageData = new ImageData(arr, originalImageWidth, originalImageHeight);
	
		// Clear the canvas
		ctx.clearRect(0, 0, canvas.width, canvas.height);
	
		// Put the compressed image onto the canvas
		ctx.putImageData(imageData, 0, 0);
	
		// Get the canvas data URL
		const href2 = canvas.toDataURL('image/png');
		setHref(href2);
		setLoading(ELoading.SUCCESS);
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
