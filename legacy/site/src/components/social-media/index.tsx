import {
	FaBrandsInstagram,
	FaBrandsReddit,
	FaBrandsTiktok,
} from "solid-icons/fa";

import { type Component, For } from "solid-js";

const accounts = [
	{
		icon: FaBrandsInstagram,
		label: "@periodt.tracker",
		url: "https://www.instagram.com/periodt.tracker",
	},
	{
		icon: FaBrandsTiktok,
		label: "@periodt.tracker",
		url: "https://www.tiktok.com/@periodt.tracker",
	},
	{
		icon: FaBrandsReddit,
		label: "u/periodt-tracker",
		url: "https://www.reddit.com/user/periodt-tracker",
	},
] as const;

const SocialMedia: Component = () => {
	return (
		<section class="flex flex-row text-white gap-4">
			<For each={accounts}>
				{(account) => (
					<a
						href={account.url}
						class="inline-flex place-items-center gap-1 group"
					>
						<account.icon class="size-6" />
						<span class="group-hover:underline hidden md:block text-lg">
							{account.label}
						</span>
					</a>
				)}
			</For>
		</section>
	);
};

export default SocialMedia;
