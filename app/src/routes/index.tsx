import { createSignal, onCleanup, type Component } from "solid-js";
import CycleWheel from "../lib/components/cycle";
import { useSettings } from "../lib/settings";
import { FaSolidBars, FaSolidCalendar, FaSolidGear, FaSolidHouse, FaSolidPlus } from "solid-icons/fa";
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuItem,
	DropdownMenuLabel,
	DropdownMenuSeparator,
	DropdownMenuTrigger,
} from "../lib/components/dropdown";
import CycleTimeline from "../lib/components/timeline";

const HomePage: Component = () => {
	const app = useSettings();

	const [scrollY, setScrollY] = createSignal(0);

	// Update scroll position
	const onScroll = () => setScrollY(window.scrollY);

	window.addEventListener("scroll", onScroll);
	onCleanup(() => window.removeEventListener("scroll", onScroll));

	const maxScroll = () => document.body.scrollHeight - window.innerHeight;
	const controlY = () => {
		const initialY = 0;
		const finalY = 50; // how much curve shrinks
		return initialY + (finalY - initialY) * (scrollY() / 500);
	};

	return (
		<main id="periodt__homepage" class="bg-white h-full min-h-svh">
			<div
				id="periodt__period-status"
				class="w-svw min-h-[70svh] bg-period-secondary relative flex flex-col pt-4"
			>
				<section class="pt-8 flex flex-col gap-8">
					<section class="flex flex-row justify-between text-white place-items-center px-8">
						<div class="text-4xl">
							Hello <span class="font-semibold">{app.settings.name}!</span>
						</div>

						<DropdownMenu>
							<DropdownMenuTrigger>
								<FaSolidBars size={32} />
							</DropdownMenuTrigger>

							<DropdownMenuContent class="text-lg">
								<DropdownMenuLabel>My Account</DropdownMenuLabel>
								<DropdownMenuSeparator />
								<DropdownMenuItem>Profile</DropdownMenuItem>
								<DropdownMenuItem>Billing</DropdownMenuItem>
								<DropdownMenuItem>Team</DropdownMenuItem>
								<DropdownMenuItem>Subscription</DropdownMenuItem>
							</DropdownMenuContent>
						</DropdownMenu>
					</section>

					<section class="px-8">
						<CycleWheel />
					</section>

					<CycleTimeline />
				</section>

				<svg viewBox="0 0 600 100" class="w-full mt-auto">
					<path d={`M0,100 C200,${controlY()} 400,${controlY()} 600,100`} fill="white" />
				</svg>
			</div>
			<p class="text-black p-8">
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce eu tellus id eros
				ullamcorper lacinia. Aliquam viverra venenatis ligula, a dapibus augue dignissim in.
				Nulla cursus, velit sed tempus tincidunt, tortor mi congue augue, vitae faucibus diam
				sapien in tortor. Sed placerat interdum augue, non condimentum nulla congue vitae.
				Curabitur felis dolor, semper sed nibh non, auctor aliquet eros. Morbi suscipit enim in
				semper ullamcorper. Sed efficitur lectus in facilisis laoreet. Sed tristique at nisi
				eget cursus. Mauris pharetra congue nulla, vitae porttitor ante ultricies vitae. Duis
				blandit libero massa, non rutrum metus gravida quis. Nulla facilisi. Fusce nec molestie
				purus, in venenatis dui. Mauris porttitor nunc ac fermentum porta. Vivamus accumsan leo
				consequat, accumsan enim vitae, ultricies metus. Duis ac tincidunt mauris. Duis luctus
				tortor vitae lobortis venenatis. Maecenas eu sollicitudin felis, eu feugiat magna. Sed
				felis erat, tempor sit amet ligula eu, semper sagittis ante. Maecenas et risus vehicula,
				blandit lectus ac, pretium nisi. Etiam gravida justo sapien. In cursus mi vitae egestas
				mattis. Aliquam erat volutpat. Nam aliquam elit vel tincidunt volutpat. Duis nec
				venenatis libero, vehicula ultricies ante. Pellentesque faucibus ipsum a nisi pretium
				sagittis. Aenean interdum ac ligula at varius. Integer mattis odio orci, mattis
				malesuada eros dapibus ac. Aenean vitae velit nisl. Maecenas quis maximus neque, nec
				vestibulum justo. Nunc porta feugiat est sit amet congue. Aenean ac nunc et ante
				ultricies bibendum. Pellentesque habitant morbi tristique senectus et netus et malesuada
				fames ac turpis egestas. Etiam eget arcu dapibus, congue purus in, porta elit. Vivamus
				elementum sollicitudin efficitur. Fusce ut maximus neque. Curabitur consequat ex ut elit
				luctus, nec placerat nulla tincidunt. Vestibulum viverra dolor eleifend metus hendrerit
				fringilla. Sed blandit erat ac scelerisque posuere. Quisque molestie ipsum sed ligula
				suscipit, at varius leo viverra. Integer interdum velit nec enim pretium, at mollis
				velit venenatis. Etiam posuere velit vel commodo euismod. Integer et tempor diam, ut
				posuere elit. Mauris in magna et justo fermentum ornare. Integer id tincidunt purus.
				Suspendisse nec orci porta, venenatis arcu sit amet, commodo leo. Phasellus eget metus
				porta orci gravida fringilla vel ac neque. Quisque facilisis faucibus eleifend. Integer
				lorem neque, facilisis a pharetra ac, ultricies non elit. Aliquam sodales ut odio ac
				hendrerit. Quisque imperdiet, eros nec auctor fermentum, nunc nunc porta dui, et
				vulputate massa orci id ligula. Praesent mauris eros, sodales eu interdum ac, tempus et
				nibh. Proin varius enim in elit iaculis accumsan. Duis commodo mollis enim, ac pulvinar
				lectus convallis vitae. Integer eu nulla ac urna tincidunt gravida a sed purus.
				Phasellus bibendum neque mi, vitae condimentum ligula faucibus nec. Pellentesque ornare
				felis nisl, a fringilla sapien blandit in. Etiam purus lectus, pharetra eu nibh ac,
				laoreet aliquam nisi. Sed molestie arcu et iaculis lacinia. Fusce ac ligula luctus,
				scelerisque ligula ac, volutpat est. Vestibulum nec risus id orci lobortis malesuada.
				Nam hendrerit eu arcu id rhoncus. Maecenas congue, lacus ac euismod elementum, sapien
				turpis faucibus lectus, sed mattis velit odio ut risus. Cras aliquet nunc ut arcu
				rhoncus eleifend. Vivamus eleifend convallis erat, imperdiet imperdiet neque cursus at.
				Nulla facilisi. Cras tempus bibendum ligula in mollis.
			</p>

			<div class="fixed bottom-0 flex flex-row p-4 gap-4 w-fit left-0 right-0 ml-auto mr-auto">
				<div class="bg-black text-white rounded-full grow p-4 flex flex-row gap-4 shadow-lg">
					<FaSolidHouse size={24} />
					<FaSolidCalendar size={24} />
					<FaSolidGear size={24} />
				</div>

				<button type="button" class="bg-black text-white rounded-full p-4 shadow-lg">
					<FaSolidPlus size={24} />
				</button>
			</div>
		</main>
	);
};

export default HomePage;
