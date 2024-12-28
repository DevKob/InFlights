import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightService {
  final String apiKey = '6fb67a697fcbb76b4ae5e2e4e0cd1f3f';


  // New method to fetch all flights
// Method to fetch all flights
  Future<List<dynamic>> fetchAllFlights() async {
    final url = Uri.parse('http://api.aviationstack.com/v1/flights?access_key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load all flight data: ${response.body}');
    }
  }
}
