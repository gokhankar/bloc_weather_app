import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:weather_app/secrets.dart";

class WeatherDataProvider {
  Future<String> getCurrentWeather(String cityName) async {
    print("getCurrentWeather WeatherDataProvider called");

    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      if (kDebugMode) {
        print("Weather data provider :  ${res.body}");
      }
      print(res.body.toString());

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
