import 'dart:ui';

import 'package:Weather/bloc/weather_bloc.dart';
import 'package:Weather/widget/sun_rise_set.dart';
import 'package:Weather/widget/uv_temperature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now = DateTime.now();
  late bool isDay;
  late Weather weather;

  String greeting = "";
  String? getWeatherAnimation(String condition) {
    switch (condition.trim()) {
      case 'clear sky':
        return isDay ? 'clear_sky_day.json' : 'clear_sky_night.json';
      case 'few clouds':
        return isDay ? 'few_cloud_day.json' : 'few_cloud_night.json';
      case 'rain':
      case 'shower rain':
        return isDay ? 'rain_day.json' : 'rain_night.json';
      case 'snow':
        return isDay ? 'snow_day.json' : 'snow_night.json';
      case 'scattered clouds':
      case 'overcast clouds':
        return 'scattered_cloud.json';
      case 'mist':
        return 'mist.json';
      case 'thunderstorm':
        return 'thunderstorm.json';
      default:
        return 'thunderstorm.json';
    }
  }

  void getGreeting() {
    int hours = now.hour;
    if (hours >= 1 && hours <= 12) {
      greeting = "Good Morning";
    } else if (hours >= 12 && hours <= 16) {
      greeting = "Good Afternoon";
    } else if (hours >= 16 && hours <= 21) {
      greeting = "Good Evening";
    } else if (hours >= 21 && hours <= 24) {
      greeting = "Good Night";
    }
    if (hours >= 6 && hours <= 18) {
      isDay = true;
    } else {
      isDay = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getGreeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherSuccessState) {
            return Padding(
              padding:
                  const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(3.0, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.deepPurple),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-3.0, -0.3),
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.deepPurple),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, -1.2),
                      child: Container(
                        height: 300,
                        width: 400,
                        decoration:
                            const BoxDecoration(color: Color(0xFFFFAB40)),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, -0.5),
                      child: Container(
                        height: 80,
                        width: 300,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 219, 38, 195)),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Builder(builder: (context) {
                      weather = state.weather;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather.areaName ?? 'Loading city',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              greeting,
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Center(
                              child: Lottie.asset(
                                  'assets/${getWeatherAnimation(weather.weatherDescription.toString())}'),
                            ),
                            Center(
                              child: Text(
                                '${weather.temperature?.celsius?.round().toString()}°C',
                                style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                            Center(
                              child: Text(
                                weather.weatherDescription?.toUpperCase() ??
                                    'Loading',
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'icons/low-temperature.png',
                                      width: 52,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "TempMin",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "${weather.tempMin?.celsius?.floor()}°C",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'icons/high-temperature.png',
                                      width: 52,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "TempMax",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "${weather.tempMax?.celsius?.round()}°C",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            SunRiseSet(weather: weather),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            UvTemperature(weather: weather),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            );
          } else if (state is WeatherFailedState) {
            return Center(
                child: Text(
              "Failed to load data\nError: ${state.errorMessage}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24),
            ));
          } else {
            return const Center(
              child: Text(
                "Unknown Error",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
