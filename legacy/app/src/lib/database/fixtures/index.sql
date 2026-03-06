insert into daily_logs (log_id, date, note, created_at, updated_at) values
  (1, '2026-01-01', 'Period started', 1704067200, 1704067200),
  (2, '2026-01-02', null,               1704153600, 1704153600),
  (3, '2026-01-03', null,               1704240000, 1704240000),
  (4, '2026-01-04', 'Feeling better',   1704326400, 1704326400),
  (5, '2026-01-05', null,               1704412800, 1704412800);

insert into bleeding_entries
  (log_id, bleeding_level, spotting, clots, notes, created_at, updated_at)
values
  (1, 4, 0, 1, 'Heavy flow', 1704067200, 1704067200),
  (2, 3, 0, 0, null,         1704153600, 1704153600),
  (3, 1, 1, 0, 'Tapering',   1704240000, 1704240000);

insert into bleeding_entries
  (log_id, bleeding_level, spotting, clots, notes, created_at, updated_at)
values
  (1, 4, 0, 1, 'Heavy flow', 1704067200, 1704067200),
  (2, 3, 0, 0, null,         1704153600, 1704153600),
  (3, 1, 1, 0, 'Tapering',   1704240000, 1704240000);

insert into sex_entries
  (log_id, sex_type, created_at, updated_at)
values
  (2, 'protected', 1704153600, 1704153600),
  (5, 'unprotected', 1704412800, 1704412800);

insert into mood_entries
  (log_id, mood_type, created_at, updated_at)
values
  (1, 'crampy',   1704068000, 1704068000),
  (1, 'irritable',1704072000, 1704072000),

  (2, 'tired',    1704155000, 1704155000),

  (3, 'sad',      1704243000, 1704243000),
  (3, 'anxious',  1704247000, 1704247000),

  (4, 'happy',    1704329000, 1704329000),
  (4, 'energetic',1704333000, 1704333000);
