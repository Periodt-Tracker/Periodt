import type { NumberRange } from "./types";

export function rangeAverage(range: NumberRange) {
	return (range.upper + range.lower) / 2;
}

export function discreteRangeAverage(range: NumberRange) {
	const average = rangeAverage(range);

	return Math.round(average);
}

export function isOutside(range: NumberRange, value: number) {
	return value <= range.lower || value >= range.upper;
}
