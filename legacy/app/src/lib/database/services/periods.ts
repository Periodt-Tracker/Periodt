import { isEmpty } from "radash";
import type { DatabasePeriod } from "../models";
import type { ServiceContext } from "../types";

export interface PeriodQuery {
	from?: string;
	to?: string;
	limit?: number;
	offset?: number;
}

export interface PeriodBuilder {
	start_date: string;
	duration: number;
}

export interface PeriodUpdater {
	start_date?: string | undefined;
	duration?: number | undefined;
}

export async function fetchPeriods(
	query: PeriodQuery,
	context: ServiceContext,
) {
	const { limit = 128, offset = 0 } = query;

	return await context.database.readTransaction(async (transaction) => {
		const periods = await transaction.getAll<DatabasePeriod>(
			/* sql */
			`
			select	
				period_id,
				start_date,
				duration,
				created_at,
				updated_at
			from
				periods
			order by start_date
			limit $2
			offset $3
			`,
			[limit, offset],
		);

		return periods;
	});
}

export async function addPeriod(
	builder: PeriodBuilder,
	context: ServiceContext,
) {
	return await context.database.writeTransaction(async (transaction) => {
		await transaction.execute(
			/* sql */
			`
			insert into periods (start_date, duration)
			values ($1, $2)
			`,
			[builder.start_date, builder.duration],
		);
	});
}

export async function updatePeriod(
	period_id: number,
	updates: PeriodUpdater,
	context: ServiceContext,
) {
	if (isEmpty(updates)) {
		return;
	}

	return await context.database.writeTransaction(async (transaction) => {
		await transaction.execute(
			/* sql */
			`
			update 
				periods
			set
				start_date = coalesce($1, start_date),
				duration = coalesce($2, duration)
			where
				period_id = $3	
			`,
			[period_id, updates.start_date, updates.duration],
		);
	});
}

export async function deletePeriod(period_id: number, context: ServiceContext) {
	return await context.database.writeTransaction(async (transaction) => {
		await transaction.execute(
			/* sql */
			`
			delete from periods
			where period_id = $1
			`,
			[period_id],
		);
	});
}
