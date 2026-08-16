import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../services/map_service.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapService mapService = MapService();

  @override
  Widget build(BuildContext context) {
    final LatLng location = mapService.getDefaultLocation();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Locations'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.studentlink',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_pin,
                  size: 45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}