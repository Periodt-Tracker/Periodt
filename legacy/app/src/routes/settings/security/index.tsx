import type { Component } from "solid-js";

import Page from "@/lib/components/page";
import Settings from "@/lib/components/settings";
import { Switch, SwitchControl, SwitchThumb } from "@/lib/components/switch";
import { RadioGroup, RadioGroupItem } from "@/lib/components/radio-group";
import { useSettings, type SecurityMethod } from "@/lib/settings";
import { useLocale } from "@/lib/i18n";

const SecuritySettingsPage: Component = () => {
	const context = useSettings();

	const { t } = useLocale();

	return (
		<main class="w-full h-svh bg-cycle-secondary">
			<Page.Header>
				<Page.HeaderBackButton />

				<Page.HeaderTitle>{t("settings.security.title")}</Page.HeaderTitle>
			</Page.Header>

			<div class="h-28 shrink-0"></div>

			<div class="flex-1 rounded-2xl overflow-hidden mb-4 mx-4">
				<div class=" h-full overflow-y-auto no-scrollbar flex flex-col gap-4">
					<Settings.Group>
						<RadioGroup
							value={context.settings.securtiy ?? "none"}
							onChange={(value) => {
								context.setSettings("securtiy", value as SecurityMethod);
							}}
						>
							<section>
								<Settings.Tab>
									<Settings.TabContent>
										<Settings.TabTitle>
											{t("settings.security.device.title")}
										</Settings.TabTitle>
										<Settings.TabDescription>
											{t("settings.security.device.description")}
										</Settings.TabDescription>
									</Settings.TabContent>

									<RadioGroupItem value="device" />
								</Settings.Tab>
							</section>

							<Settings.Divider />

							<Settings.Tab>
								<Settings.TabContent>
									<Settings.TabTitle>
										{t("settings.security.pin.title")}
									</Settings.TabTitle>
									<Settings.TabDescription>
										{t("settings.security.pin.description")}
									</Settings.TabDescription>
								</Settings.TabContent>

								<RadioGroupItem value="pin" />
							</Settings.Tab>

							<Settings.Divider />

							<Settings.Tab>
								<Settings.TabContent>
									<Settings.TabTitle>
										{t("settings.security.none.title")}
									</Settings.TabTitle>
									<Settings.TabDescription>
										{t("settings.security.none.description")}
									</Settings.TabDescription>
								</Settings.TabContent>

								<RadioGroupItem value="none" />
							</Settings.Tab>
						</RadioGroup>
					</Settings.Group>

					<Settings.Group>
						<section>
							<Settings.Tab
								onClick={() =>
									context.setSettings("blank_screen", (blank) => !blank)
								}
							>
								<Settings.TabContent>
									<Settings.TabTitle>
										{t("settings.security.blank_screen.title")}
									</Settings.TabTitle>
									<Settings.TabDescription>
										{t("settings.security.blank_screen.description")}
									</Settings.TabDescription>
								</Settings.TabContent>

								<Switch checked={context.settings.blank_screen ?? false}>
									<SwitchControl>
										<SwitchThumb />
									</SwitchControl>
								</Switch>
							</Settings.Tab>
						</section>

						<Settings.Divider />

						<Settings.Tab>
							<Settings.TabContent>
								<Settings.TabTitle>
									{t("settings.security.lock_on_resume.title")}
								</Settings.TabTitle>
								<Settings.TabDescription>
									{t("settings.security.lock_on_resume.description")}
								</Settings.TabDescription>
							</Settings.TabContent>

							<Switch
								checked={context.settings.lock_on_resume ?? false}
								onChange={(value) => {
									context.setSettings("lock_on_resume", value);
								}}
							>
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

export default SecuritySettingsPage;
