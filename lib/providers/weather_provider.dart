import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? weather;
  bool isLoading = false;
  String? error;
  String? lastSearchedCity;

  final String apiKey = 'b497671913bd1fba1cdd2e1934497fd0'; // Replace with your OpenWeather API key

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        weather = Weather.fromJson(jsonResponse);
        lastSearchedCity = city;
      } else {
        error = 'Failed to load weather data';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
