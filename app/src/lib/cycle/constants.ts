import { keys } from "../utilities/object";

export const phase = {
	period: "period",
	follicular: "follicular",
	ovulation: "ovulation",
	luteal: "luteal",
} as const;

export const phases = keys(phase);
