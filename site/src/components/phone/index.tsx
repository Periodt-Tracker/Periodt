import type { Component } from "solid-js";

import phone from "@/assets/phone.webp";

const Phone: Component = () => {
	return (
		<img
			id="periodt__phone-image"
			alt="Phone"
			src={phone}
			class="m-auto max-h-full max-w-8/10 lg:w-auto"
		/>
	);
};

export default Phone;
