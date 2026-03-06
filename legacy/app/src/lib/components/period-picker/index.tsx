import Page from "@/lib/components/page";
import { useLocale } from "@/lib/i18n";
import { useSettings } from "@/lib/settings";
import { merge } from "@/lib/utilities/class";
import { addDays, daysBetween } from "@/lib/utilities/date";
import { discreteRangeAverage, isOutside } from "@/lib/utilities/range";
import Calendar from "@corvu/calendar";
import { FaSolidAngleLeft, FaSolidAngleRight } from "solid-icons/fa";
import { type Component, createSignal, Index, onMount, Show } from "solid-js";
import Button from "../button";
import Months from "./months";
import { DateTime } from "luxon";
import { database } from "@/lib/database";
import { addPeriod } from "@/lib/database/services/periods";

const PeriodPicker: Component = () => {
	const { t } = useLocale();
	const now = new Date();

	const context = useSettings();

	const [value, setValue] = createSignal<{
		from: Date | null;
		to: Date | null;
	}>({ from: null, to: null });

	const initialMonth = () => DateTime.now().minus({ years: 9, months: 11 });

	const isFuture = (date: Date) => {
		return date > now;
	};

	const periodLength = () => {
		return discreteRangeAverage(context.settings.period_length);
	};

	const selectionLength = () => {
		const range = value();

		if (!range.from || !range.to) {
			return null;
		}

		return daysBetween(range.from, range.to);
	};

	const warningBounds = () => {
		const period_range = context.settings.period_length;

		const lower_offset = Math.ceil(Math.log2(period_range.lower + 1));
		const upper_offset = Math.ceil(Math.log2(period_range.upper + 1));

		const lower_bound = period_range.lower - lower_offset;
		const upper_bound = period_range.upper + upper_offset;

		return { lower: lower_bound, upper: upper_bound };
	};

	const warning = () => {
		const selection = selectionLength();

		if (!selection) {
			return false;
		}

		const bounds = warningBounds();
		return isOutside(bounds, selection);
	};

	const hasSelection = () => {
		const selection = value();

		return selection.to && selection.from;
	};

	onMount(async () => {
		console.log("Hiiii");

		const result = await addPeriod({ start_date: "2026-02-23", duration: 5 }, { database });

		alert(result);
	});

	return (
		<main class="w-full h-svh bg-white flex flex-col">
			<Page.Header class="bg-white">
				<Page.HeaderBackButton />

				<Page.HeaderTitle>{t("phase.period_picker.title")}</Page.HeaderTitle>
			</Page.Header>
			<div class="h-28 shrink-0"></div>
			<div class="p-4">
				<div class="overflow-y-scroll">
					<Calendar
						mode="range"
						numberOfMonths={120}
						value={value()}
						onValueChange={(range) => {
							const previous = value();

							if (!previous.from && !previous.to) {
								const start = range.from ?? range.to;
								if (!start) return;

								const length = periodLength();
								const end = addDays(start, length - 1);

								setValue({ from: start, to: end });
								return;
							}

							if (!range.from || !previous.from || !previous.to) {
								setValue(range);
								return;
							}

							if (range.from > previous.from && range.from < previous.to) {
								setValue({ from: previous.from, to: range.from });
								return;
							}

							if (range.from < previous.from) {
								setValue({ from: range.from, to: previous.to });
								return;
							}

							if (range.from > previous.to) {
								setValue({ from: previous.from, to: range.from });
								return;
							}

							setValue(range);
						}}
						initialMonth={initialMonth().toJSDate()}
						disabled={isFuture}
					>
						{(props) => (
							<div class="relative rounded-md bg-corvu-100 p-3 md:my-8">
								<Calendar.Nav
									action="prev-month"
									aria-label="Go to previous month"
									class="absolute left-3 size-7 rounded-sm bg-corvu-200/50 p-0.75 hover:bg-corvu-200"
								>
									<FaSolidAngleLeft size="18" />
								</Calendar.Nav>

								<Calendar.Nav
									action="next-month"
									aria-label="Go to next month"
									class="absolute right-3 size-7 rounded-sm bg-corvu-200/50 p-0.75 hover:bg-corvu-200"
								>
									<FaSolidAngleRight size="18" />
								</Calendar.Nav>

								<Months calendar={props} />
							</div>
						)}
					</Calendar>
				</div>
			</div>
			<Show when={hasSelection()}>
				<Button class="absolute bottom-8 w-fit left-0 right-0 mx-auto animate-in slide-in-from-bottom-20">
					Clear
				</Button>
			</Show>
			Warning? {warning() ? "Yes" : "no"}
			<Button class="m-4 mt-auto">Submit</Button>
		</main>
	);
};

export default PeriodPicker;
