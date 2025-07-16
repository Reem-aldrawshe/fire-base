class Khetma {
  final String? id;
  final String name;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFajriyah;
  final bool isPriority;

  Khetma({
    this.id,
    required this.name,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.isFajriyah,
    required this.isPriority,
  });

  factory Khetma.fromMap(Map<String, dynamic> map) {
    return Khetma(
      id: map['id'],
      name: map['name'],
      intention: map['intention'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      isFajriyah: map['is_fajriyah'] ?? false,
      isPriority: map['is_priority'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'intention': intention,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_fajriyah': isFajriyah,
      'is_priority': isPriority,
    };
  }
}
