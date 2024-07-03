import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = 'b497671913bd1fba1cdd2e1934497fd0';

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Weather.fromJson({
        'name': jsonResponse['location']['name'],
        'main': {
          'temp': jsonResponse['current']['temp_c'],
          'humidity': jsonResponse['current']['humidity'],
        },
        'weather': [
          {
            'description': jsonResponse['current']['condition']['text'],
            'icon': jsonResponse['current']['condition']['icon'].split('/').last.replaceAll('.png', ''),
          },
        ],
        'wind': {
          'speed': jsonResponse['current']['wind_kph'] / 3.6, // converting km/h to m/s
        },
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
