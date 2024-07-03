import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Weather Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<WeatherProvider>(context, listen: false);
              if (provider.lastSearchedCity != null) {
                provider.fetchWeather(provider.lastSearchedCity!);
              }
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return Center(child: Text(provider.error!));
          } else if (provider.weather == null) {
            return const Center(child: Text('No weather data available'));
          } else {
            final weather = provider.weather!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      weather.description,
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      'https://openweathermap.org/img/wn/${weather.icon}@2x.png', // Updated icon URL
                      scale: 1.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error); // Placeholder icon for error case
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Humidity: ${weather.humidity}%',style: const TextStyle(fontSize: 20),),
                    const SizedBox(height: 8),
                    Text('Wind Speed: ${weather.windSpeed.toStringAsFixed(1)} m/s',style: const TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
