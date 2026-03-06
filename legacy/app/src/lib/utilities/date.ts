export function toIso(date: Date) {
	return date.toISOString().split("T")[0];
}

export function todayIso() {
	const today = new Date();

	return toIso(today);
}

export function optionalMin(a: Date | null, b: Date | null) {
	if (a === null || b === null) {
		return null;
	}

	return a <= b ? a : b;
}

export function optionalMax(a: Date | null, b: Date | null) {
	if (a === null || b === null) {
		return null;
	}

	return a >= b ? a : b;
}

export function addDays(date: Date, days: number) {
	const result = new Date(date.getTime());
	result.setDate(result.getDate() + days);

	return result;
}

export function daysBetween(a: Date, b: Date) {
	const deltaMs = a.getTime() - b.getTime();
	const deltaDays = Math.round(deltaMs / (1000 * 60 * 60 * 24));

	return Math.abs(deltaDays);
}

export function isFuture(date: Date) {
	const now = new Date();

	return date > now;
}
