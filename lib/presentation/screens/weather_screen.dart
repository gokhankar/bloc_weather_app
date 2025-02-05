import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/widgets/additional_info_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  // Future<Map<String, dynamic>> getCurrentWeather() async {
  //   try {
  //     String cityName = 'London';
  //     final res = await http.get(
  //       Uri.parse(
  //         'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
  //       ),
  //     );

  //     final data = jsonDecode(res.body);

  //     if (data['cod'] != '200') {
  //       throw 'An unexpected error occurred';
  //     }

  //     return data;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // weather = getCurrentWeather();
    context.read<WeatherBloc>().add(WeatherFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // setState(() {
              //   // weather = getCurrentWeather();
              // });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        // future: weather,
        builder: (context, state) {
          var currentCity = "";
          var currentTemp = "";
          var currentSky = "";
          var currentPressure = "";
          var currentWindSpeed = "";
          var currentHumidity = "";
          if (state is WeatherFailure) {
            Center(
              child: Text(state.error),
            );
          }
          if (state is WeatherLoading) {
            const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is WeatherSuccess) {
            final data = state.weatherModel;
            currentCity = data.city!.name.toString();
            currentTemp = data.list![0].main!.temp.toString();
            currentSky = data.list![0].weather![0].main.toString();
            currentPressure = data.list![0].main!.pressure.toString();
            currentWindSpeed = data.list![0].wind!.speed.toString();
            currentHumidity = data.list![0].main!.humidity.toString();
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator.adaptive(),
          //   );
          // }

          // if (snapshot.hasError) {
          //   return Center(
          //     child: Text(snapshot.error.toString()),
          //   );
          // }

          // final data = snapshot.data!;

          // final currentWeatherData = data['list'][0];

          // final currentTemp = currentWeatherData['main']['temp'];
          // final currentSky = currentWeatherData['weather'][0]['main'];
          // final currentPressure = currentWeatherData['main']['pressure'];
          // final currentWindSpeed = currentWeatherData['wind']['speed'];
          // final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentCity ',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // SizedBox(
                //   height: 120,
                //   child: ListView.builder(
                //     itemCount: 5,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       final hourlyForecast = data;
                //       final hourlySky =
                //           data['list'][index + 1]['weather'][0]['main'];
                //       final hourlyTemp =
                //           hourlyForecast['main']['temp'].toString();
                //       final time = DateTime.parse(hourlyForecast['dt_txt']);
                //       return HourlyForecastItem(
                //         time: DateFormat.j().format(time),
                //         temperature: hourlyTemp,
                //         icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                //             ? Icons.cloud
                //             : Icons.sunny,
                //       );
                //     },
                //   ),
                // ),

                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
