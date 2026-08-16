class StudyLocation {
  // The database automatically creates this ID.
  final int? id;

  // Information displayed on the location screen.
  final String name;
  final String address;
  final String description;

  // Coordinates used to place the location on a map.
  final double latitude;
  final double longitude;

  const StudyLocation({
    this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  // Converts the object into values SQLite can store.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Creates a StudyLocation object from a database row.
  factory StudyLocation.fromMap(Map<String, dynamic> map) {
    return StudyLocation(
      id: map['id'] as int?,
      name: map['name'] as String,
      address: map['address'] as String,
      description: map['description'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  StudyLocation copyWith({
    int? id,
    String? name,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
  }) {
    return StudyLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'StudyLocation(id: $id, name: $name, address: $address, '
        'latitude: $latitude, longitude: $longitude)';
  }
}