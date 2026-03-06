import type { MaybeAccessor, MaybeAccessorValue } from "./types";

export const access = <T extends MaybeAccessor<any>>(
	v: T,
): MaybeAccessorValue<T> =>
	typeof v === "function" && !v.length ? v() : (v as any);
