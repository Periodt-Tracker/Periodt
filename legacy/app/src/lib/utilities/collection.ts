export function sum(values: number[]) {
	return values.reduce((previous, next) => previous + next, 0);
}

export function intoArray<T>(value: T | T[]): T[] {
	if (Array.isArray(value)) {
		return value;
	} else {
		return [value];
	}
}
