class ZikrCompetition {
  final int id;
  final String zikrText;
  final int targetCount;
  int completedCount; // ✅ بدل "completed"
  final DateTime createdAt;

  ZikrCompetition({
    required this.id,
    required this.zikrText,
    required this.targetCount,
    required this.completedCount,
    required this.createdAt,
  });

  factory ZikrCompetition.fromMap(Map<String, dynamic> map) {
    return ZikrCompetition(
      id: map['id'],
      zikrText: map['zikr_text'],
      targetCount: map['target_count'],
      completedCount: map['completed_count'], // ✅
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zikr_text': zikrText,
      'target_count': targetCount,
      'completed_count': completedCount, // ✅
    };
  }
}
