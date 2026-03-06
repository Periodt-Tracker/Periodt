import type { capSQLiteVersionUpgrade } from "@capacitor-community/sqlite";

export const DailyRecordStatements: capSQLiteVersionUpgrade = {
	toVersion: 1,
	statements: [
		/* sql */
		`
    create table if not exists daily_logs (
      log_id integer primary key,

      date text not null unique, -- ISO-8601
      note text,

      created_at integer not null,
      updated_at integer
    );
    `,
		/* sql */
		`
    create table if not exists bleeding_entries (
      log_id integer primary key references daily_logs(log_id) on delete cascade,

      bleeding_level integer not null check (bleeding_level between 0 and 5),
      spotting boolean not null,
      clots boolean not null,
      notes text,

      created_at integer not null,
      updated_at integer
    );
    `,
		/* sql */
		`
    create table if not exists discharge_entries (
      log_id integer primary key references daily_logs(log_id) on delete cascade,

      colour text not null,
      odor text not null,

      created_at integer not null,
      updated_at integer
    );
    `,
		/* sql */
		`
    create table if not exists mood_entries (
      log_id integer primary key references daily_logs(log_id) on delete cascade,

      mood_type text not null,

      created_at integer not null,
      updated_at integer
    );
    `,
		/* sql */
		`
    create table if not exists sex_entries (
      log_id integer primary key references daily_logs(log_id) on delete cascade,

      sex_type text not null,

      created_at integer not null,
      updated_at integer
    );
    `,
		/* sql */
		`
    create table if not exists periods (
      period_id integer primary key,
      
      start_date text not null unique,
      duration integer not null,

      created_at integer not null,
      updated_at integer
    )   
    `,
	],
};
