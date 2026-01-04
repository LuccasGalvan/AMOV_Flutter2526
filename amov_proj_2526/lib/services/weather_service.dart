import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather.dart';
import '../utils/app_constants.dart';

class WeatherService {
  Future<Weather> fetchCurrentWeather() async {
    final uri = Uri.parse(AppConstants.openMeteoBaseUrl).replace(
      queryParameters: {
        'latitude': AppConstants.cityLatitude.toString(),
        'longitude': AppConstants.cityLongitude.toString(),
        'current_weather': 'true',
      },
    );

    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Weather request failed: HTTP ${resp.statusCode}');
    }

    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    return Weather.fromOpenMeteo(decoded);
  }

  // Optional: simple mapping for display
  static String describeWeatherCode(int code) {
    // Open-Meteo weather codes (simplified)
    if (code == 0) return 'Clear sky';
    if (code == 1 || code == 2) return 'Mostly clear';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }
}
