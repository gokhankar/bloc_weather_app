import 'dart:convert';

import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/presentation/data/network/weather_data_provider.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository(this.weatherDataProvider);

  Future<WeatherModel> getCurrentWeather() async {
    print("getCurrentWeather called");
    try {
      const cityName = "London";
      final weatherData = await weatherDataProvider.getCurrentWeather(cityName);

      final data = jsonDecode(weatherData as String);
      // print("xxxx : ${WeatherModel.fromJson(data).city!.name}");

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return WeatherModel.fromJson(data);
    } catch (e) {
      print("xxxx : ${e.toString()}}");
      throw e.toString();
    }
  }
}
