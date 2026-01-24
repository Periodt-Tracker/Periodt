import { Preferences } from "@capacitor/preferences";
import type z from "zod";
import type { PersistanceBackend } from "./types";

export const preferences: PersistanceBackend = {
	async set(key: string, value: unknown): Promise<void> {
		const serialized = JSON.stringify(value);
		await Preferences.set({ key, value: serialized });
	},

	async get<T>(key: string): Promise<T | null> {
		const result = await Preferences.get({ key });

		if (!result.value) {
			return null;
		}

		return JSON.parse(result.value) as T;
	},

	async getValidated<T extends z.ZodSchema>(
		key: string,
		schema: T,
	): Promise<z.ZodSafeParseResult<z.output<T>> | null> {
		const result = await Preferences.get({ key });

		if (!result.value) {
			return null;
		}

		const json = JSON.parse(result.value);
		return schema.safeParse(json);
	},

	async delete(key: string): Promise<void> {
		await Preferences.remove({ key });
	},

	async clear(): Promise<void> {
		await Preferences.clear();
	},
};
