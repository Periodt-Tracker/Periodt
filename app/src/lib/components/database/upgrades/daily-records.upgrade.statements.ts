import type { capSQLiteVersionUpgrade } from "@capacitor-community/sqlite";

export const DailyRecordStatements: capSQLiteVersionUpgrade = {
	toVersion: 1,
	statements: [
		`
    create table if not exists daily_logs (
      log_id integer primary key autoincrement,

      date text not null,
      note text,

      created_at integer not null,
      updated_at integer not null
    );
    `,
		`
    create table if not exists bleeding_entries (
      bleeding_id integer primary key autoincrement,
      log_id references daily_logs(log_id) not null on delete cascade,

      bleeding_level integer not null,
      spotting bool not null,
      clots bool not null,
      notes text,
      
      created_at integer not null,
      updated_at integer not null
    ); 
    `,
		`
    create table if not exists discharge_entries (
      discharge_id integer primary key autoincrement,
      log_id references daily_logs(log_id) not null on delete cascade,

      colour text not null,
      consistency text not null,
      odor text not null,
      
      created_at integer not null,
      updated_at integer not null
    );
    `,
		`
    create table if not exists mood_entries (
      mood_id integer priamry key autoincrement,
      log_id references daily_logs(log_id) not null on delete cascade,

      mood_type text not null,

      created_at integer not null,
      updated_at integer not null
    );
    `,
		`,
    create table if not exists sex_entries (
      sex_id integer priamry key autoincrement,
      log_id references daily_logs(log_id) not null on delete cascade,

      sex_type text not null,

      created_at integer not null,
      updated_at integer not null
    );
    `,
	],
};
