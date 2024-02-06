export const Icons: {
	[key: string]: React.FC<React.SVGProps<SVGSVGElement>>;
} = {
	spinner: (props) => (
		<svg
			xmlns="http://www.w3.org/2000/svg"
			width="24"
			height="24"
			viewBox="0 0 24 24"
			fill="none"
			stroke="currentColor"
			strokeWidth="2"
			strokeLinecap="round"
			strokeLinejoin="round"
			{...props}>
			<path d="M21 12a9 9 0 1 1-6.219-8.56" />
		</svg>
	),
	equations: (props) => (
		<svg
			{...props}
			viewBox="0 0 1024 1024"
			version="1.1"
			xmlns="http://www.w3.org/2000/svg"
			fill="currentColor">
			<g id="SVGRepo_bgCarrier" strokeWidth="0"></g>
			<g
				id="SVGRepo_tracerCarrier"
				strokeLinecap="round"
				strokeLinejoin="round"></g>
			<g id="SVGRepo_iconCarrier">
				<path
					d="M981.333333 469.333333a21.333333 21.333333 0 0 0-21.333333 21.333334v85.333333a85.333333 85.333333 0 0 1-85.333333 85.333333H149.333333a85.333333 85.333333 0 0 1-85.333333-85.333333V149.333333a85.333333 85.333333 0 0 1 85.333333-85.333333h725.333334a85.333333 85.333333 0 0 1 85.333333 85.333333 21.333333 21.333333 0 0 0 42.666667 0 128 128 0 0 0-128-128H149.333333a128 128 0 0 0-128 128v426.666667a128 128 0 0 0 128 128h725.333334a128 128 0 0 0 128-128v-85.333333a21.333333 21.333333 0 0 0-21.333334-21.333334z"
					fill="currentColor"></path>
				<path
					d="M981.333333 298.666667a21.333333 21.333333 0 0 0-21.333333 21.333333v85.333333a21.333333 21.333333 0 0 0 42.666667 0v-85.333333a21.333333 21.333333 0 0 0-21.333334-21.333333zM966.186667 219.52a21.333333 21.333333 0 0 0 0 30.293333 21.333333 21.333333 0 0 0 30.293333 0l2.56-3.413333a11.946667 11.946667 0 0 0 1.92-3.626667 13.226667 13.226667 0 0 0 1.706667-3.84 26.88 26.88 0 0 0 0-4.266666 21.333333 21.333333 0 0 0-36.48-15.146667zM896 960H128a21.333333 21.333333 0 0 0 0 42.666667h768a21.333333 21.333333 0 0 0 0-42.666667zM682.666667 853.333333a21.333333 21.333333 0 0 0 0-42.666666H341.333333a21.333333 21.333333 0 0 0 0 42.666666zM704 384a21.333333 21.333333 0 0 0 0-42.666667h-44.373333a149.333333 149.333333 0 0 0-28.16-67.84l31.36-31.36a21.333333 21.333333 0 1 0-30.08-30.08l-31.573334 31.146667A149.333333 149.333333 0 0 0 533.333333 215.04V170.666667a21.333333 21.333333 0 0 0-42.666666 0v44.373333a149.333333 149.333333 0 0 0-67.84 28.16l-31.573334-31.36a21.333333 21.333333 0 0 0-30.08 30.08l31.36 31.36A149.333333 149.333333 0 0 0 364.373333 341.333333H320a21.333333 21.333333 0 0 0 0 42.666667h44.373333a149.333333 149.333333 0 0 0 28.16 67.84l-31.36 31.36a21.333333 21.333333 0 1 0 30.08 30.08l31.36-31.36A149.333333 149.333333 0 0 0 490.666667 510.293333V554.666667a21.333333 21.333333 0 0 0 42.666666 0v-44.373334a149.333333 149.333333 0 0 0 67.84-28.16l31.36 31.36a21.333333 21.333333 0 0 0 30.08-30.08l-31.146666-31.573333A149.333333 149.333333 0 0 0 659.626667 384z m-192 85.333333a106.666667 106.666667 0 1 1 106.666667-106.666666 106.666667 106.666667 0 0 1-106.666667 106.666666z"
					fill="currentColor"></path>
			</g>
		</svg>
	),
	root: (props) => {
		return (
			<svg
				{...props}
				viewBox="0 0 24 24"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
				stroke="#currentColor">
				<g id="SVGRepo_bgCarrier" strokeWidth="0"></g>
				<g
					id="SVGRepo_tracerCarrier"
					strokeLinecap="round"
					strokeLinejoin="round"></g>
				<g id="SVGRepo_iconCarrier">
					{' '}
					<path
						d="M16.5 7.81066L7.81065 16.5H16.25C16.3881 16.5 16.5 16.3881 16.5 16.25V7.81066ZM15.8661 6.32322C16.6536 5.53576 18 6.09348 18 7.2071V16.25C18 17.2165 17.2165 18 16.25 18H7.2071C6.09346 18 5.53576 16.6536 6.32321 15.8661L15.8661 6.32322Z"
						fill="#212121"></path>{' '}
				</g>
			</svg>
		);
	},
};
