import { Repeat } from "@solid-primitives/range";
import type { Component } from "solid-js";
import { useStepper } from "./stepper-context";

const StepperIndicator: Component = () => {
  const context = useStepper();

  return (
    <div class="flex flex-row gap-2">
      <Repeat times={context.pageCount()}>
        {(count) => (
          <div
            data-active={context.currentPage() === count}
            class="w-2 h-2 rounded-full bg-gray-600 data-[active=true]:bg-period-primary"
          />
        )}
      </Repeat>
    </div>
  );
};

export default StepperIndicator;
