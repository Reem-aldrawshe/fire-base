class Zikr {
  final int? id; // ← تغير من String إلى int?
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int targetCount;
  final int completedCount;
  final int dailyTarget;
  final DateTime createdAt;

  Zikr({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.targetCount,
    this.completedCount = 0,
    required this.dailyTarget,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'target_count': targetCount,
      'completed_count': completedCount,
      'daily_target': dailyTarget,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Zikr.fromMap(Map<String, dynamic> map) {
    return Zikr(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      targetCount: map['target_count'],
      completedCount: map['completed_count'],
      dailyTarget: map['daily_target'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  int get durationInDays {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return end.difference(start).inDays + 1;
  }
}
