import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vow_weather/secrets.dart';
import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherAppPage extends StatefulWidget {
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {
  double temp = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      setState(() {
        isLoading = true;
      });
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey"),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      setState(() {
        temp = data['list'][0]['main']['temp'];
        isLoading = false;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // <---------Main Card----------->
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
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "$temp K",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Icon(
                                    Icons.cloud,
                                    size: 64,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    "Rain",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // <---------Main Card----------->
                    const SizedBox(
                      height: 20,
                    ),
                    // <-----------Weather Forecast ----------->
                    const Text(
                      "Weather Forecast",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          HourlyForecastItem(
                            time: "03:00",
                            temperature: "320.12",
                            icon: Icons.cloud,
                          ),
                          HourlyForecastItem(
                            time: "04:00",
                            temperature: "200.05",
                            icon: Icons.sunny,
                          ),
                          HourlyForecastItem(
                            time: "05:00",
                            temperature: "150.00",
                            icon: Icons.foggy,
                          ),
                          HourlyForecastItem(
                            time: "06:00",
                            temperature: "100.80",
                            icon: Icons.sunny_snowing,
                          ),
                          HourlyForecastItem(
                            time: "07:00",
                            temperature: "500.34",
                            icon: Icons.cloud,
                          ),
                        ],
                      ),
                    ),
                    // <-----------Weather Forecast ----------->
                    const SizedBox(
                      height: 20,
                    ),
                    // <-----------Additional Info ----------->
                    const Text(
                      "Additional Information",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: '91',
                        ),
                        AdditionalInfoItem(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: '7.67',
                        ),
                        AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: '1006',
                        )
                      ],
                    )
                    // <-----------Additional Info ----------->
                  ],
                ),
              ),
            ),
    );
  }
}
