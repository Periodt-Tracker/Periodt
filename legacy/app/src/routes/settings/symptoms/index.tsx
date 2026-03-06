import type { Component } from "solid-js";
import Page from "@/lib/components/page";
import Settings from "@/lib/components/settings";
import { Switch, SwitchControl, SwitchThumb } from "@/lib/components/switch";
import { useLocale } from "@/lib/i18n";
import { useSettings } from "@/lib/settings";

const SymptomsSettingsPage: Component = () => {
	const context = useSettings();
	const { t } = useLocale();

	return (
		<main class="w-full h-svh bg-cycle-secondary">
			<Page.Header>
				<Page.HeaderBackButton />

				<Page.HeaderTitle>{t("settings.symptoms.title")}</Page.HeaderTitle>
			</Page.Header>

			<div class="h-28 shrink-0"></div>

			<div class="flex-1 rounded-2xl overflow-hidden mb-4 mx-4">
				<div class=" h-full overflow-y-auto no-scrollbar flex flex-col gap-4">
					<Settings.Group>
						<Settings.Tab class="flex flex-row gap-4 justify-between w-full">
							<Settings.TabContent>
								<Settings.TabTitle>
									{t("settings.symptoms.title")}
								</Settings.TabTitle>

								<Settings.TabDescription>
									{t("settings.symptoms.description")}
								</Settings.TabDescription>
							</Settings.TabContent>

							<Switch checked={context.settings.blank_screen ?? false}>
								<SwitchControl>
									<SwitchThumb />
								</SwitchControl>
							</Switch>
						</Settings.Tab>
					</Settings.Group>
				</div>
			</div>
		</main>
	);
};

export default SymptomsSettingsPage;
