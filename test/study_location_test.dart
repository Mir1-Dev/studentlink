import 'package:flutter_test/flutter_test.dart';
import 'package:studentlink/models/study_location.dart';

void main() {
  group('StudyLocation model tests', () {
    test('StudyLocation converts to a database map', () {
      const StudyLocation location = StudyLocation(
        id: 1,
        name: 'Waterloo Public Library',
        address: '35 Albert Street',
        description: 'A quiet study location.',
        latitude: 43.4667,
        longitude: -80.5248,
      );

      final Map<String, dynamic> map = location.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Waterloo Public Library');
      expect(map['address'], '35 Albert Street');
      expect(map['description'], 'A quiet study location.');
      expect(map['latitude'], 43.4667);
      expect(map['longitude'], -80.5248);
    });

    test('StudyLocation is created from a database map', () {
      final Map<String, dynamic> map = {
        'id': 2,
        'name': 'Campus Library',
        'address': 'Waterloo Campus',
        'description': 'Campus study space.',
        'latitude': 43.4796,
        'longitude': -80.5170,
      };

      final StudyLocation location = StudyLocation.fromMap(map);

      expect(location.id, 2);
      expect(location.name, 'Campus Library');
      expect(location.address, 'Waterloo Campus');
      expect(location.latitude, 43.4796);
      expect(location.longitude, -80.5170);
    });
  });
}