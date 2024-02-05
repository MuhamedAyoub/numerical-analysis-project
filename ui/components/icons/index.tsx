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
