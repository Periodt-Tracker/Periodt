import { createSignal, For, Index, onMount, type Component } from "solid-js";
import * as Calendar from "@corvu/calendar";
import { createVirtualizer } from "@tanstack/solid-virtual";
import { VirtualList } from "../virtual";

const { format: formatWeekdayLong } = new Intl.DateTimeFormat("en", {
	weekday: "long",
});
const { format: formatWeekdayShort } = new Intl.DateTimeFormat("en", {
	weekday: "short",
});
const { format: formatMonth } = new Intl.DateTimeFormat("en", {
	month: "long",
});

export interface MonthsProps {
	calendar: Calendar.RootChildrenRangeProps;
}

const Months: Component<MonthsProps> = (props) => {
	return (
		<div class="space-y-8 md:flex md:space-x-4 md:space-y-0 overflow-auto text-center">
			<VirtualList
				each={props.calendar.months}
				overscanCount={5}
				rootHeight={600}
				rowHeight={384}
			>
				{(month, index) => (
					<div class="h-96">
						<div class="flex h-7 items-center justify-center">
							<Calendar.Label index={index()} class="text-sm">
								{formatMonth(month.month)} {month.month.getFullYear()}
							</Calendar.Label>
						</div>

						<Calendar.Table index={index()} class="mt-3 table-fixed w-full">
							<thead>
								<tr>
									<Index each={props.calendar.weekdays}>
										{(weekday) => (
											<Calendar.HeadCell
												abbr={formatWeekdayLong(weekday())}
												class="w-8 flex-1 pb-1 text-xs font-normal opacity-65"
											>
												{formatWeekdayShort(weekday())}
											</Calendar.HeadCell>
										)}
									</Index>
								</tr>
							</thead>

							<tbody>
								<Index each={month.weeks}>
									{(week) => (
										<tr>
											<Index each={week()}>
												{(day) => (
													<Calendar.Cell class="p-0 has-data-range-end:rounded-r-md has-data-range-start:rounded-l-md has-data-in-range:bg-period-primary has-[[disabled]]:opacity-40 has-data-in-range:first:rounded-l-md has-data-in-range:last:rounded-r-md">
														<Calendar.CellTrigger
															day={day()}
															month={month.month}
															class="inline-flex size-8 items-center justify-center rounded-md text-sm focus-visible:bg-corvu-200/80 disabled:pointer-events-none data-today:bg-corvu-200/50 data-range-start:bg-corvu-300 data-range-end:bg-corvu-300 lg:hover:not-data-range-start:not-data-range-end:bg-corvu-200/80 mb-6 pb-2"
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
			</VirtualList>
		</div>
	);
};

export default Months;
