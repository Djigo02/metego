import 'dart:convert';
import 'package:http/http.dart' as http;

class Meteo{

  Future<Map<String, dynamic>> fetchWeatherData(String cityName) async {
    final apiKey = 'cb4816bd696b648d6331924525902163'; //Ma clé API OpenWeather
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Echec lors de la connexion');
    }
  }

}