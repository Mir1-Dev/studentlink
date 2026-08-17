import 'package:latlong2/latlong.dart';

import '../models/study_location.dart';

class MapService {
  LatLng getDefaultLocation() {
    return const LatLng(43.4120, -80.4905);
  }

  List<StudyLocation> getConestogaDoonLocations() {
    return [
      const StudyLocation(
        name: 'SLC Library',
        campus: 'Doon Campus',
        type: 'Library',
        latitude: 43.4120,
        longitude: -80.4905,
        isQuiet: true,
      ),
      const StudyLocation(
        name: 'Student Commons',
        campus: 'Doon Campus',
        type: 'Study Area',
        latitude: 43.4125,
        longitude: -80.4895,
        isQuiet: false,
      ),
      const StudyLocation(
        name: 'Quiet Study Pods',
        campus: 'Doon Campus',
        type: 'Study Pods',
        latitude: 43.4115,
        longitude: -80.4910,
        isQuiet: true,
      ),
      const StudyLocation(
        name: 'Main Cafeteria',
        campus: 'Doon Campus',
        type: 'Cafeteria',
        latitude: 43.4130,
        longitude: -80.4915,
        isQuiet: false,
      ),
      const StudyLocation(
        name: 'Tech Lab',
        campus: 'Doon Campus',
        type: 'Computer Lab',
        latitude: 43.4110,
        longitude: -80.4900,
        isQuiet: true,
      ),
    ];
  }
}