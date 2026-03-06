import type { DayEntry } from "@/lib/symptoms/types";
import { toIso } from "@/lib/utilities/date";
import type { ServiceContext } from "../types";

export async function loadDailyLog(date: string, context: ServiceContext) {
	return await context.database.getOptional(
		/* sql */
		`
    select
      daily_log.log_id,
      date text not null, 

    `,
	);
}

export async function storeDailyLog(log: DayEntry, context: ServiceContext) {
	await context.database.writeTransaction(async (transaction) => {
		const now = new Date();

		const date = toIso(now);
		const timestamp = now.getTime();

		const { insertId: log_id } = await transaction.execute(
			/* sql */
			`
      insert into daily_logs (date, note, created_at)
      values (?, ?, ?)
      returning log_id
      `,
			[date, log.note, timestamp],
		);

		if (!log_id) {
			transaction.rollback();
			return;
		}

		if (log.bleeding) {
			const data = log.bleeding;

			await transaction.execute(
				/* sql */
				`
        insert into bleeding_entries (
          log_id, bleeding_level, spotting, clots, notes
        ),
        values (?, ?, ?, ?, ?)
        `,
				[log_id, data.level, data.spotting, data.clots, data.notes],
			);
		}
	});
}
