import type { Component } from "solid-js";

import highlight from "@/assets/highlight.svg";

const Title: Component = () => {
	return (
		<h1 class="text-white font-semibold text-4xl lg:text-8xl z-50 inline-block relative">
			Your{" "}
			<span class="relative w-fit h-fit">
				<img
					class="absolute top-0 left-0 z-0"
					src={highlight}
					alt="highlight"
				/>
				<span class="relative z-50">private</span>
			</span>
			<br /> Periodt. tracker
		</h1>
	);
};

export default Title;
