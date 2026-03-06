import type { Entries, Keys, Values } from "./types";

export function keys<T extends object>(object: T): Keys<T> {
	return Object.keys(object) as Keys<T>;
}

export function values<T extends object>(object: T): Values<T> {
	return Object.values(object) as Values<T>;
}

export function entries<T extends object>(object: T): Entries<T> {
	return Object.entries(object) as Entries<T>;
}

export function isEmpty(object: object) {
	for (const value of Object.values(object)) {
		if (value !== undefined) {
			return false;
		}
	}

	return true;
}
