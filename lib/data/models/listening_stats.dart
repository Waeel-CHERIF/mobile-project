class ListeningStats {
  final String userId;
  final Duration totalListeningTime;
  final Map<String, double> monthlyListeningHours;
  final Map<String, int> trackPlayCounts;

  ListeningStats({
    required this.userId,
    required this.totalListeningTime,
    required this.monthlyListeningHours,
    required this.trackPlayCounts,
  });

  double get currentMonthHours {
    final now = DateTime.now();
    final key = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return monthlyListeningHours[key] ?? 0.0;
  }

  List<MapEntry<String, int>> get topTracks {
    final sorted = trackPlayCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(10).toList();
  }

  Map<String, double> get last7DaysData {
    final data = <String, double>{};
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      data[key] = monthlyListeningHours[key] ?? 0.0;
    }

    return data;
  }

  factory ListeningStats.empty(String userId) {
    return ListeningStats(
      userId: userId,
      totalListeningTime: Duration.zero,
      monthlyListeningHours: {},
      trackPlayCounts: {},
    );
  }

  ListeningStats copyWith({
    String? userId,
    Duration? totalListeningTime,
    Map<String, double>? monthlyListeningHours,
    Map<String, int>? trackPlayCounts,
  }) {
    return ListeningStats(
      userId: userId ?? this.userId,
      totalListeningTime: totalListeningTime ?? this.totalListeningTime,
      monthlyListeningHours: Map.from(monthlyListeningHours ?? this.monthlyListeningHours),
      trackPlayCounts: Map.from(trackPlayCounts ?? this.trackPlayCounts),
    );
  }
}
