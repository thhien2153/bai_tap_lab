import 'package:clima_flutter/services/networking.dart';
import '/services/location.dart';

const apiKey = 'apikey';
const weatherApiURL = 'http://api.weatherapi.com/v1/current.json';

class WeatherModel {
  Future<dynamic> getCityWeather(String inputCity) async {
    NetworkHelper networkHelper =
        NetworkHelper(url: '$weatherApiURL?key=$apiKey&q=$inputCity&aqi=yes');

    dynamic weatherCityData = await networkHelper.getData();

    return weatherCityData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        url:
            '$weatherApiURL?key=$apiKey&q=${location.latitude},${location.longitude}&aqi=yes');

    dynamic weatherLocationData = await networkHelper.getData();

    return weatherLocationData;
  }

  String getWeatherIcon(int condition) {
    if (condition <= 1087 || condition >= 1072) {
      return '🌩';
    } else if (condition <= 1183 || condition >= 1180) {
      return '🌧';
    } else if (condition <= 1195 || condition >= 1192) {
      return '☔️';
    } else if (condition <= 1225 || condition >= 1222) {
      return '☃️';
    } else if (condition < 1003) {
      return '☀️';
    } else if (condition <= 1006 || condition >= 1003) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
