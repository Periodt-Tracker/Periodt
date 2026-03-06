import { FaSolidArrowLeft } from "solid-icons/fa";
import type { Component } from "solid-js";
import blob from "@/assets/question/question_512.png";
import Button from "@/lib/components/button";
import BackButton from "@/lib/components/link/back-button";
import { useLocale } from "@/lib/i18n";

const FallbackPage: Component = () => {
	const { t } = useLocale();

	return (
		<div class="bg-cycle-secondary w-svw h-svh grid place-items-center text-center p-12">
			<div class="flex flex-col place-items-center gap-4">
				<img class="h-52 w-fit" src={blob} alt="blob" />

				<span class="text-2xl text-period-primary font-semibold">{t("fallback.title")}</span>

				<span class="text-lg text-white">{t("fallback.description")}</span>
			</div>

			<BackButton as={Button} class="flex flex-row gap-2 w-full justify-center place-items-center">
				<FaSolidArrowLeft /> {t("fallback.return")}
			</BackButton>
		</div>
	);
};

export default FallbackPage;
