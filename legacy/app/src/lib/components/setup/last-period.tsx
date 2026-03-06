import Calendar from "@corvu/calendar";
import { FaSolidCaretLeft, FaSolidCaretRight } from "solid-icons/fa";
import { type Component, Index } from "solid-js";
import { discreteRangeAverage } from "@/lib/utilities/range";
import type { SetupForm } from "@/routes/setup";
import { useStepper } from "../stepper/stepper-context";
import { merge } from "@/lib/utilities/class";

const { format: formatWeekdayLong } = new Intl.DateTimeFormat("en", {
  weekday: "long",
});
const { format: formatWeekdayShort } = new Intl.DateTimeFormat("en", {
  weekday: "short",
});
const { format: formatMonth } = new Intl.DateTimeFormat("en", {
  month: "long",
});

export const LastPeriod: Component = () => {
  const context = useStepper<SetupForm>();

  const period_length = () => discreteRangeAverage(context.form.period_length);

  const today = new Date();

  return (
    <div>
      <h2 class="text-3xl font-semibold">How long is your usual cycle?</h2>

      <Calendar mode="range" disabled={(date) => date > today}>
        {(props) => (
          <div class="my-4 rounded-md bg-corvu-100 md:my-8">
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
                        abbr={formatWeekdayLong(
                          weekday(),
                        )}
                        class="w-12 pb-1 text-sm font-normal opacity-65"
                      >
                        {formatWeekdayShort(
                          weekday(),
                        )}
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
                                "size-8 rounded-md text-lg focus-visible:bg-corvu-200/80 disabled:pointer-events-none disabled:opacity-40",
                                "ui-selected:bg-period-primary! data-today:bg-corvu-200/50 lg:hover:bg-corvu-200/80",
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
  );
};

export default LastPeriod;
