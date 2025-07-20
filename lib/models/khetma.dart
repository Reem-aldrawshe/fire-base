class Khetma {
  final int? id;
  final String name;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFajriyah;
  final bool isPublic;

  Khetma({
    this.id,
    required this.name,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.isFajriyah,
    required this.isPublic,
  });

  factory Khetma.fromMap(Map<String, dynamic> map) {
    return Khetma(
      id: map['id'],
      name: map['name'],
      intention: map['intention'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      isFajriyah: map['is_fajriyah'] ?? false,
      isPublic: map['is_public'] ?? false, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'intention': intention,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_fajriyah': isFajriyah,
      'is_public': isPublic, 
    };
  }


  Khetma copyWith({
  int? id,
  String? name,
  String? intention,
  DateTime? startDate,
  DateTime? endDate,
  bool? isFajriyah,
  bool? isPublic,
}) {
  return Khetma(
    id: id ?? this.id,
    name: name ?? this.name,
    intention: intention ?? this.intention,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    isFajriyah: isFajriyah ?? this.isFajriyah,
    isPublic: isPublic ?? this.isPublic,
  );
}

}
