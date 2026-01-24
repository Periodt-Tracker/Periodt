import type { ISQLiteService } from "./service";

export interface ServiceContext {
	service: ISQLiteService;
}

export interface PeriodQuery {
	before?: Date;
	since?: Date;
	limit?: number;
	offset?: number;
}
