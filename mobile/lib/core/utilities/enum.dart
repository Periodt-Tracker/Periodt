enum ItemType { toast, coffee, muffin }

Map<E, int> countConsecutiveEnums<E extends Enum>(List<E> items) {
  final Map<E, int> counts = {};

  if (items.isEmpty) {
    return counts;
  }

  for (final item in items) {
    counts.update(item, (value) => value + 1, ifAbsent: () => 1);
  }

  return counts;
}
