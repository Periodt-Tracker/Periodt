List<int> range(int from, int to) =>
    List.generate(to - from + 1, (i) => i + from);
