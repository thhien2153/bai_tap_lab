import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({required this.url});

  final String url;

  Future<dynamic> getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
      // var temp = jsonDecode(data)['current']['temp_c'];
      // var weatherDesc = jsonDecode(data)['current']['condition']['text'];
    }
  }
}
