export function toIsoDateOnly(date: Date) {
  return date.toISOString().split("T")[0];
}

export function todayIso() {
  const today = new Date();

  return toIsoDateOnly(today);
}
