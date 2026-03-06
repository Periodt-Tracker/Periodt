import { test } from "vitest";
import { database } from "../../src/lib/database";

test("adds 1 + 2 to equal 3", async () => {
	await database.get(`select * from periods`);
});
