import type { Component } from "solid-js";
import { StepperContext } from "./stepper-context";

const StepperRoot: Component = () => {
  return <StepperContext.Provider context={ }></StepperContext.Provider>;
};

export default StepperRoot;
