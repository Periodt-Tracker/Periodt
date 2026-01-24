import Calendar from "@corvu/calendar";
import { FaSolidCaretLeft, FaSolidCaretRight } from "solid-icons/fa";
import { type Component, Index } from "solid-js";

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
	return (
		<div>
			<Calendar mode="single">
				{(props) => (
					<div class="my-4 rounded-md bg-corvu-100 p-3 shadow-md md:my-8">
						<div class="flex items-center justify-between">
							<Calendar.Nav
								action="prev-month"
								aria-label="Go to previous month"
								class="size-7 rounded-sm bg-corvu-200/50 p-1.25 hover:bg-corvu-200"
							>
								<FaSolidCaretLeft size="18" />
							</Calendar.Nav>
							<Calendar.Label class="text-sm">
								{formatMonth(props.month)} {props.month.getFullYear()}
							</Calendar.Label>
							<Calendar.Nav
								action="next-month"
								aria-label="Go to next month"
								class="size-7 rounded-sm bg-corvu-200/50 p-1.25 hover:bg-corvu-200"
							>
								<FaSolidCaretRight size="18" />
							</Calendar.Nav>
						</div>
						<Calendar.Table class="mt-3">
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
															class="size-10 rounded-md text-lg focus-visible:bg-corvu-200/80 disabled:pointer-events-none disabled:opacity-40 data-selected:bg-corvu-300! data-today:bg-corvu-200/50 lg:hover:bg-corvu-200/80"
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
	);
};

export default HistoryPage;
