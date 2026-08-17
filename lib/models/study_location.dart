class StudyLocation {
  const StudyLocation({
    this.id,
    required this.name,
    required this.campus,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.isQuiet = false,
  });

  final int? id;
  final String name;
  final String campus;
  final String type;
  final double latitude;
  final double longitude;
  final bool isQuiet;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'campus': campus,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'is_quiet': isQuiet ? 1 : 0,
    };
  }

  factory StudyLocation.fromMap(Map<String, dynamic> map) {
    return StudyLocation(
      id: map['id'] as int?,
      name: map['name'] as String,
      campus: map['campus'] as String,
      type: map['type'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      isQuiet: (map['is_quiet'] as int?) == 1,
    );
  }
}
