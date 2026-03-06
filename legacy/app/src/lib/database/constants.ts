export const row_update_type = {
	sqlite_insert: 18,
	sqlite_delete: 9,
	sqlite_update: 23,
} as const;

export const sqlite_synchronous = {
	normal: "NORMAL",
	full: "FULL",
	off: "OFF",
} as const;
