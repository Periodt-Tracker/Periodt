import Page from "@/lib/components/page";
import { useLocale } from "@/lib/i18n";
import { useSettings } from "@/lib/settings";
import { merge } from "@/lib/utilities/class";
import {
	addDays,
	daysBetween,
	optionalMax,
	optionalMin,
} from "@/lib/utilities/date";
import { discreteRangeAverage, isOutside } from "@/lib/utilities/range";
import Calendar from "@corvu/calendar";
import { FaSolidAngleLeft, FaSolidAngleRight } from "solid-icons/fa";
import { type Component, createSignal, Index } from "solid-js";

const { format: formatWeekdayLong } = new Intl.DateTimeFormat("en", {
	weekday: "long",
});
const { format: formatWeekdayShort } = new Intl.DateTimeFormat("en", {
	weekday: "short",
});
const { format: formatMonth } = new Intl.DateTimeFormat("en", {
	month: "long",
});

const HistoryPage: Component = () => {
	const { t } = useLocale();

	const context = useSettings();

	const [value, setValue] = createSignal<{
		from: Date | null;
		to: Date | null;
	}>({ from: null, to: null });

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

	return (
		<main class="w-full h-svh">
			<Page.Header class="bg-white">
				<Page.HeaderBackButton />

				<Page.HeaderTitle>{t("phase.period_picker.title")}</Page.HeaderTitle>
			</Page.Header>
			<div class="h-28 shrink-0"></div>
			<div class="p-4">
				<Calendar
					mode="range"
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
				>
					{(props) => (
						<div class="my-4 rounded-md bg-corvu-100 p-3 shadow-md md:my-8">
							<div class="flex items-center justify-between">
								<Calendar.Nav
									action="prev-month"
									aria-label="Go to previous month"
									class="size-7 rounded-sm bg-corvu-200/50 p-1.25 hover:bg-corvu-200"
								>
									<FaSolidAngleLeft size="18" />
								</Calendar.Nav>
								<Calendar.Label class="text-sm">
									{formatMonth(props.month)} {props.month.getFullYear()}
								</Calendar.Label>
								<Calendar.Nav
									action="next-month"
									aria-label="Go to next month"
									class="size-7 rounded-sm bg-corvu-200/50 p-1.25 hover:bg-corvu-200"
								>
									<FaSolidAngleRight size="18" />
								</Calendar.Nav>
							</div>

							<Calendar.Table class="mt-3 full font-mono text-center">
								<thead>
									<tr>
										<Index each={props.weekdays}>
											{(weekday) => (
												<Calendar.HeadCell
													abbr={formatWeekdayLong(weekday())}
													class="w-8 pb-1 text-lg font-normal opacity-65"
												>
													{formatWeekdayShort(weekday())}
												</Calendar.HeadCell>
											)}
										</Index>
									</tr>
								</thead>

								<tbody>
									<Index each={props.weeks}>
										{(week) => (
											<tr>
												<Index each={week()}>
													{(day) => (
														<Calendar.Cell class="p-0">
															<Calendar.CellTrigger
																day={day()}
																class={merge(
																	"size-10 text-lg rounded-none focus-visible:bg-corvu-200/80 disabled:pointer-events-none disabled:opacity-40",
																	"ui-selected:bg-period-primary! data-range-end:rounded-r-lg data-range-start:rounded-l-lg",
																)}
															>
																{day().getDate()}
															</Calendar.CellTrigger>
														</Calendar.Cell>
													)}
												</Index>
											</tr>
										)}
									</Index>
								</tbody>
							</Calendar.Table>
						</div>
					)}
				</Calendar>
			</div>
			Warning? {warning() ? "Yes" : "no"}
		</main>
	);
};

export default HistoryPage;
