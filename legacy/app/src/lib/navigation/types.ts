import type { Accessor, Component } from "solid-js";

export interface Page {
  name: string;

  component: Component;
}

export interface OverlayOptions {
  transition?: string;
}

export interface Overlay extends OverlayOptions {
  component: Component;
}

export interface NavigatorContextType {
  overlayStack: Accessor<Overlay[]>;

  setPage: (screen: string) => void;

  overlay: (component: Component, options?: OverlayOptions) => void;

  back: VoidFunction;

  reset: VoidFunction;
}
