import type { Accessor } from "solid-js";

export type Keys<T> = (keyof T)[];

export type Values<T> = T[keyof T][];

export type Entries<T> = { [K in keyof T]: [K, T[K]] }[keyof T];

export type MaybePromise<T> = T | Promise<T>;

export type Maybe<T> = T | null | undefined;

export type MaybeAccessor<T> = T | Accessor<T>;

export type NumberRange = { lower: number; upper: number };
