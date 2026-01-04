import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';
import '../utils/app_constants.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    CategoriesScreen(),
    FavoritesScreen(),
  ];

  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService().fetchCurrentWeather();
  }

  void _refreshWeather() {
    setState(() {
      _weatherFuture = WeatherService().fetchCurrentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _index == 0 ? 'Categories' : 'Favorites';

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConstants.appTitle} — $title'),
        actions: [
          IconButton(
            tooltip: 'Refresh weather',
            onPressed: _refreshWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppConstants.homeBackgroundAssetPath,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // overlay for readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          // Your existing content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: _WeatherCard(future: _weatherFuture),
              ),
              Expanded(child: _pages[_index]),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Future<Weather> future;
  const _WeatherCard({required this.future});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<Weather>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('Loading weather...'),
                ],
              );
            }

            if (snapshot.hasError) {
              return Text('Weather unavailable: ${snapshot.error}');
            }

            final w = snapshot.data!;
            final desc = WeatherService.describeWeatherCode(w.weatherCode);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.cityName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(desc),
                    const SizedBox(height: 4),
                    Text('Wind: ${w.windSpeed.toStringAsFixed(1)} km/h'),
                  ],
                ),
                Text(
                  '${w.temperatureC.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
