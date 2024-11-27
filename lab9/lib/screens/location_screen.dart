import 'package:clima_flutter/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/utilities/constants.dart';
import '/services/weather.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.weatherData});

  final dynamic weatherData;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int? temperature;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;
  WeatherModel weather = WeatherModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'ERROR';
        cityName = '';
        return;
      } else {
        double temp = weatherData['current']['temp_c'];
        temperature = temp.toInt();
        var condition = weatherData['current']['condition']['code'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature!);
        cityName = weatherData['location']['name'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: SpinKitChasingDots(
                color: Colors.white,
                size: 100.0,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('images/location_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
              constraints: const BoxConstraints.expand(),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () async {
                            dynamic weatherData =
                                await weather.getLocationWeather();
                            updateUI(weatherData);
                          },
                          child: const Icon(
                            Icons.near_me,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            var typedName = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {                            
                              return const CityScreen();
                            }));
                            if (typedName != null) {
                              setState(() {
                                isLoading = true;
                              });
                              var weatherData =
                                  await weather.getCityWeather(typedName);                             
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                isLoading = false;
                              });
                              if (weatherData != null) {
                                updateUI(weatherData);
                              }
                            }
                          },
                          child: const Icon(
                            Icons.location_city,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '$temperature',
                            style: kTempTextStyle,
                          ),
                          Text(
                            weatherIcon!,
                            style: kConditionTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        '$weatherMessage in $cityName',
                        textAlign: TextAlign.right,
                        style: kMessageTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
