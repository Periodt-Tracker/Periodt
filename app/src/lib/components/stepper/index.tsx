import { Repeat } from "@solid-primitives/range";
import { createSignal, For, Match, mergeProps, Switch, type Component, type JSX } from "solid-js";
import { StepperContext } from "./stepper-context";
import Button from "../button";
import { FaSolidArrowRight } from "solid-icons/fa";

export interface StepperProps {
  pages: JSX.Element[];

  initialPage?: number;
}

const Stepper: Component<StepperProps> = (__props) => {
  const props = mergeProps({ initialPage: 0 }, __props);

  const [page, setPage] = createSignal(props.initialPage);

  const pageCount = () => props.pages.length;

  const nextPage = () => {
    const currentPage = page();
    const maxPage = pageCount() - 1;

    if (currentPage === maxPage) {
      return;
    }

    setPage(currentPage + 1);
  };

  const previousPage = () => {
    const currentPage = page();

    if (currentPage === 0) {
      return;
    }

    setPage(currentPage - 1);
  };

  return (
    <StepperContext.Provider value={{ nextPage, previousPage, page, pageCount }}>
      <div class="flex flex-col h-full">
        <div class="grow">
          <Switch>
            <For each={props.pages}>
              {(component, index) => (
                <Match when={page() === index()}>{component}</Match>
              )}
            </For>
          </Switch>

          <Button
            class="mt-6 w-full flex place-items-center gap-2 justify-center"
            onClick={nextPage}
          >
            Continue
            <FaSolidArrowRight />
          </Button>
        </div>

        <div class="flex flex-row gap-2 m-auto place-items-center">
          <Repeat times={props.pages.length}>
            {(index) => (
              <div
                data-active={index === page()}
                class="w-3 h-3 rounded-full bg-gray-400 data-[active=true]:bg-period-primary data-[active=true]:w-4 data-[active=true]:h-4"
              />
            )}
          </Repeat>
        </div>
      </div>
    </StepperContext.Provider>
  );
};

export default Stepper;
