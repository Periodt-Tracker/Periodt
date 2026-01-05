import type { Component } from "solid-js";
import SocialMedia from "@/components/social-media";
import Phone from "@/components/phone";
import ComingSoon from "@/components/coming-soon";
import Title from "@/components/title";

const LandingPage: Component = () => {
	return (
		<main class="w-svw h-svh bg-period-primary overflow-hidden">
			<section class="relative h-full flex flex-col lg:flex-row p-8 lg:p-16 max-w-[1440px] m-auto gap-6">
				<section class="flex flex-col grow gap-2 text-center lg:text-left">
					<Title />

					<span class="text-white text-2xl lg:text-4xl">
						Your health, on your device.
					</span>

					<section class="flex flex-col-reverse lg:flex-col lg:mt-auto mx-auto lg:mx-0 place-items-center lg:place-items-baseline gap-4">
						<ComingSoon />

						<SocialMedia />
					</section>
				</section>

				<Phone />
			</section>
		</main>
	);
};

export default LandingPage;
