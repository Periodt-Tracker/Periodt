import { createSignal, type Component } from "solid-js";

const tabs = {
  home: "home",
  calendar: "calendar",
  settings: "settings",
} as const;

export type TabType = (typeof tabs)[keyof typeof tabs];

const Navbar: Component = () => {
  const [active, setActive] = createSignal<TabType>("home");

  return <section class="flex items-center gap-4"></section>;
};

export default Navbar;
