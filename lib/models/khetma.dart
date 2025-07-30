class Khetma {
  final int? id;
  final String name;
  final String intention;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFajriyah;
  final bool isPublic;
  final int? peopleCount;      
  final String? names;        
  Khetma({
    this.id,
    required this.name,
    required this.intention,
    required this.startDate,
    required this.endDate,
    required this.isFajriyah,
    required this.isPublic,
    this.peopleCount,       
    this.names,               
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
      peopleCount: map['people_count'],     
      names: map['names'],                 
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
      'people_count': peopleCount,        
      'names': names,                     
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
    int? peopleCount,                    
    String? names,                       
  }) {
    return Khetma(
      id: id ?? this.id,
      name: name ?? this.name,
      intention: intention ?? this.intention,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isFajriyah: isFajriyah ?? this.isFajriyah,
      isPublic: isPublic ?? this.isPublic,
      peopleCount: peopleCount ?? this.peopleCount,   
      names: names ?? this.names,                    
    );
  }
}
