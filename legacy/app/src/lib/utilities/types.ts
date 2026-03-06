import type { Accessor } from "solid-js";

export type Keys<T> = (keyof T)[];

export type Values<T> = T[keyof T][];

export type Entries<T> = { [K in keyof T]: [K, T[K]] }[keyof T];

export type MaybePromise<T> = T | Promise<T>;

export type Maybe<T> = T | null | undefined;

export type MaybeAccessor<T> = T | Accessor<T>;

export type NumberRange = { lower: number; upper: number };

export type Result<T, E> =
	| { success: true; data: T; error?: never }
	| { success: false; data?: never; error?: E };

export type MaybeAccessorValue<T extends MaybeAccessor<unknown>> =
	T extends () => any ? ReturnType<T> : T;
