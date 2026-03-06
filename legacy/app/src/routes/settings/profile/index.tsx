import {
	createEffect,
	createSignal,
	Index,
	Show,
	type Component,
} from "solid-js";
import Page from "@/lib/components/page";
import Settings from "@/lib/components/settings";
import { FaSolidCheck, FaSolidCircle, FaSolidUser } from "solid-icons/fa";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogTitle,
	DialogTrigger,
} from "@/lib/components/dialog";
import { CloseButton } from "@kobalte/core/dialog";
import Button from "@/lib/components/button";
import { TextField, TextFieldInput } from "@/lib/components/text";
import { useSettings } from "@/lib/settings";
import { useLocale } from "@/lib/i18n";

const NameEditor = () => {
	const context = useSettings();

	const [value, setValue] = createSignal(context.settings.name);

	const error = () => {
		const name = value();

		if (name.length <= 0) {
			return "Your name cannot be empty";
		} else if (name.length > 128) {
			return "Your name is too long";
		}

		return null;
	};

	const valid = () => error() === null;

	const handleSubmit = () => {
		if (valid()) {
			return;
		}

		context.setSettings("name", value());
	};

	createEffect(() => setValue(context.settings.name));

	return (
		<Dialog>
			<DialogTrigger as={Button}>Edit</DialogTrigger>

			<DialogContent>
				<DialogTitle>Update your name</DialogTitle>

				<TextField value={value()} onChange={setValue}>
					<TextFieldInput
						class="focus-visible:border-cycle-primary"
						placeholder="Jane Doe"
					/>
				</TextField>

				<DialogDescription></DialogDescription>

				<DialogFooter>
					<CloseButton as={Button} onClick={handleSubmit}>
						Submit
					</CloseButton>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
};

const LocaleEditor = () => {
	const { t, locale, ...context } = useLocale();

	const details = () => {
		const current_locale = locale();

		return context.locale_details[current_locale];
	};

	return (
		<Dialog>
			<DialogTrigger class="flex flex-row gap-2">
				<img alt="flag" src={details().flag} />
				{t(`settings.locale.${locale()}`)}
			</DialogTrigger>

			<DialogContent class="flex flex-col gap-4">
				<DialogTitle>{t("settings.locale.select")}</DialogTitle>

				<Index each={context.available_locales}>
					{(entry) => (
						<button
							type="button"
							onClick={() => context.setLocale(entry().key)}
							class="flex gap-2 place-items-center"
						>
							<div class="w-4 h-4">
								<Show when={entry().key === locale()}>
									<FaSolidCircle class="text-cycle-primary size-3" />
								</Show>
							</div>

							<img alt={entry().key} src={entry().flag} />

							<span class="">{t(`settings.locale.${entry().key}`)}</span>
						</button>
					)}
				</Index>

				<DialogFooter>
					<CloseButton as={Button}>{t("settings.locale.confirm")}</CloseButton>
				</DialogFooter>
			</DialogContent>
		</Dialog>
	);
};

const ProfileSettingsPage: Component = (props) => {
	const context = useSettings();

	return (
		<main class="w-full h-svh bg-cycle-secondary">
			<Page.Header>
				<Page.HeaderBackButton />

				<Page.HeaderTitle>Profile</Page.HeaderTitle>
			</Page.Header>

			<div class="h-26 shrink-0"></div>

			<div class="flex-1 rounded-2xl overflow-hidden mb-4 mx-4">
				<div class=" h-full overflow-y-auto no-scrollbar flex flex-col gap-4">
					<Settings.Group>
						<Settings.Tab>
							<Settings.TabContent>
								<Settings.TabTitle>Name</Settings.TabTitle>
								<Settings.TabDescription>
									{context.settings.name}
								</Settings.TabDescription>
							</Settings.TabContent>

							<NameEditor />
						</Settings.Tab>

						<Settings.Divider />

						<Settings.Tab>
							<Settings.TabContent>
								<Settings.TabTitle>Language</Settings.TabTitle>

								<Settings.TabDescription></Settings.TabDescription>
							</Settings.TabContent>

							<LocaleEditor />
						</Settings.Tab>
					</Settings.Group>
				</div>
			</div>
		</main>
	);
};

export default ProfileSettingsPage;
