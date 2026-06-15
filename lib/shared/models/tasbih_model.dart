class TasbihState {
  final int count;
  final int total;
  final int target;
  final String dhikrName;

  const TasbihState({
    required this.count,
    required this.total,
    required this.target,
    required this.dhikrName,
  });

  TasbihState copyWith({
    int? count,
    int? total,
    int? target,
    String? dhikrName,
  }) {
    return TasbihState(
      count: count ?? this.count,
      total: total ?? this.total,
      target: target ?? this.target,
      dhikrName: dhikrName ?? this.dhikrName,
    );
  }

  double get progress => target > 0 ? (count / target).clamp(0.0, 1.0) : 0.0;
}
