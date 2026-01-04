class Weather {
  final double temperatureC;
  final int weatherCode;
  final double windSpeed;
  final String timeIso;

  const Weather({
    required this.temperatureC,
    required this.weatherCode,
    required this.windSpeed,
    required this.timeIso,
  });

  factory Weather.fromOpenMeteo(Map<String, dynamic> json) {
    final cw = (json['current_weather'] as Map?)?.cast<String, dynamic>() ?? {};
    final temp = cw['temperature'];
    final code = cw['weathercode'];
    final wind = cw['windspeed'];
    final time = cw['time'];

    return Weather(
      temperatureC: temp is num ? temp.toDouble() : double.tryParse('$temp') ?? 0.0,
      weatherCode: code is num ? code.toInt() : int.tryParse('$code') ?? 0,
      windSpeed: wind is num ? wind.toDouble() : double.tryParse('$wind') ?? 0.0,
      timeIso: (time ?? '').toString(),
    );
  }
}
