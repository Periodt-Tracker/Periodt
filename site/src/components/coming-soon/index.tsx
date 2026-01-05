import type { Component } from "solid-js";

import comingSoon from "@/assets/coming-soon.svg";

const ComingSoon: Component = () => {
	return (
		<img
			id="periodt__coming-soon"
			class="w-40 lg:w-56"
			src={comingSoon}
			alt="Coming Soon"
		/>
	);
};

export default ComingSoon;
