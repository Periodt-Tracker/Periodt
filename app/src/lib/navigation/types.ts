import type { Accessor, Component } from "solid-js";

export interface Route {
  component: Component;
  tranition?: string;
}

export interface NavigatorContextType {
  stack: Accessor<Route[]>;

  push: (page: string) => void;

  pop: VoidFunction;

  reset: VoidFunction;
}
