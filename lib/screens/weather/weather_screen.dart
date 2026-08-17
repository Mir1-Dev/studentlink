import 'package:flutter/material.dart';

import '../../services/weather_service.dart';
import '../../widgets/app_logo.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  final WeatherService weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: AppLogo(size: 24),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherService.getWeather(
          latitude: 43.4643,
          longitude: -80.5204,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load weather'),
            );
          }

          final data = snapshot.data!;
          final current = data['current'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud,
                  size: 80,
                ),
                const SizedBox(height: 20),

                Text(
                  '${current['temperature_2m']} °C',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Wind Speed: ${current['wind_speed_10m']} km/h',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}