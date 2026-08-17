import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/study_location.dart';
import '../../services/map_service.dart';
import '../../widgets/app_logo.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapService mapService = MapService();

  @override
  Widget build(BuildContext context) {
    final LatLng location = mapService.getDefaultLocation();
    final locations = mapService.getConestogaDoonLocations();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Study Locations',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: AppLogo(size: 24),
        ),
      ),
      body: Column(
        children: [
          // Map Section
          SizedBox(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: location,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.studentlink',
                ),
                MarkerLayer(
                  markers: locations
                      .map(
                        (loc) => Marker(
                          point: LatLng(loc.latitude, loc.longitude),
                          width: 50,
                          height: 50,
                          child: Icon(
                            loc.isQuiet
                                ? Icons.location_pin
                                : Icons.location_on_outlined,
                            size: 40,
                            color: loc.isQuiet
                                ? const Color(0xFF62B99A)
                                : const Color(0xFF62A7E8),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          // Locations List Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Doon Campus Study Spots',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF17233F),
                    ),
                  ),
                ),
                ...locations.map(
                  (location) => _LocationCard(location: location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.location});

  final StudyLocation location;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: location.isQuiet
                ? const Color(0xFF62B99A).withValues(alpha: 0.16)
                : const Color(0xFF62A7E8).withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(
            location.isQuiet ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            size: 20,
            color: location.isQuiet
                ? const Color(0xFF62B99A)
                : const Color(0xFF62A7E8),
          ),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF17233F),
          ),
        ),
        subtitle: Text(
          location.type,
          style: const TextStyle(
            color: Color(0xFF7B879E),
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: location.isQuiet
                ? const Color(0xFF62B99A).withValues(alpha: 0.1)
                : const Color(0xFF62A7E8).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            location.isQuiet ? 'Quiet' : 'Active',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: location.isQuiet
                  ? const Color(0xFF62B99A)
                  : const Color(0xFF62A7E8),
            ),
          ),
        ),
      ),
    );
  }
}