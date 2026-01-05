import type { ClassValue } from "clsx";
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function merge(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}
