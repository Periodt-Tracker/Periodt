import { Button } from "@kobalte/core/button";
import {
	FaSolidDroplet,
	FaSolidMagnifyingGlass,
	FaSolidShield,
	FaSolidUniversalAccess,
	FaSolidUser,
} from "solid-icons/fa";
import type { Component } from "solid-js";

import blob from "@/assets/cog/cog_512.png";
import Page from "@/lib/components/page";
import Settings from "@/lib/components/settings";
import { useLocale } from "@/lib/i18n";
import { useSettings } from "@/lib/settings";
import { useNavigator } from "@/lib/navigation/navigator-context";

export const SettingsPage: Component = (props) => {
	const navigator = useNavigator();
	const context = useSettings();

	const { t } = useLocale();

	return (
		<main class=" w-full h-svh flex flex-col bg-cycle-secondary px-4 overflow-hidden">
			<Page.Header>
				<Page.HeaderBackButton />

				<Page.HeaderTitle>{t("settings.title")}</Page.HeaderTitle>

				<Button class="absolute right-4">
					<FaSolidMagnifyingGlass size={22} />
				</Button>
			</Page.Header>

			<div class="h-20 shrink-0"></div>

			<div class="flex-1 rounded-2xl overflow-hidden mb-4">
				<div class="h-full overflow-y-auto no-scrollbar flex flex-col gap-4">
					<div class="p-8 w-fit mx-auto animate-in zoom-in-85 duration-700">
						<img class="h-48" src={blob} alt="fuck" />
					</div>

					<Settings.Group>
						<Settings.Tab
							onClick={() => navigator.push("profile_settings")}
							class="flex flex-row gap-4"
						>
							<Settings.TabIcon class="bg-period-primary" icon={FaSolidUser} />

							<Settings.TabContent>
								<Settings.TabTitle>
									{t("settings.profile.title")}
								</Settings.TabTitle>

								<Settings.TabDescription>
									{t("settings.profile.description")}
								</Settings.TabDescription>
							</Settings.TabContent>
						</Settings.Tab>

						<Settings.Divider />

						<Settings.Tab href="/settings/cycle">
							<Settings.TabIcon
								class="bg-luteal-primary"
								icon={FaSolidDroplet}
							/>

							<Settings.TabContent>
								<Settings.TabTitle>My Cycle</Settings.TabTitle>
								<Settings.TabDescription>
									Name, Language
								</Settings.TabDescription>
							</Settings.TabContent>
						</Settings.Tab>
					</Settings.Group>

					<Settings.Group>
						<Settings.Tab href="/settings/profile" class="flex flex-row gap-4">
							<Settings.TabIcon class="bg-period-primary" icon={FaSolidUser} />

							<Settings.TabContent>
								<Settings.TabTitle>About</Settings.TabTitle>
								<Settings.TabDescription>
									Name, Language
								</Settings.TabDescription>
							</Settings.TabContent>
						</Settings.Tab>

						<Settings.Divider />

						<Settings.Tab onClick={() => navigator.push("security_settings")}>
							<Settings.TabIcon
								class="bg-luteal-primary"
								icon={FaSolidShield}
							/>

							<Settings.TabContent>
								<Settings.TabTitle>
									{t("settings.security.title")}
								</Settings.TabTitle>
								<Settings.TabDescription>
									{t("settings.security.description")}
								</Settings.TabDescription>
							</Settings.TabContent>
						</Settings.Tab>

						<Settings.Divider />

						<Settings.Tab href="/settings/accessibility">
							<Settings.TabIcon
								class="bg-ovulation-primary"
								icon={FaSolidUniversalAccess}
							/>

							<Settings.TabContent>
								<Settings.TabTitle>
									{t("settings.accessibility.title")}
								</Settings.TabTitle>
								<Settings.TabDescription>
									{t("settings.accessibility.description")}
								</Settings.TabDescription>
							</Settings.TabContent>
						</Settings.Tab>
					</Settings.Group>

					<span class="text-xl font-semibold text-cycle-primary text-center">
						Periodt.
					</span>
				</div>
			</div>

			<button
				type="button"
				onClick={() => context.setSettings("setup_complete", false)}
			>
				Reset
			</button>
		</main>
	);
};

export default SettingsPage;
