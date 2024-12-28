import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight.dart';

Future<List<Flight>> fetchFlights() async {
  final response = await http.get(Uri.parse('https://aviation-edge.com/v2/public/flights?key=ac813a-a5c9ec'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((flight) => Flight.fromJson(flight)).toList();
  } else {
    throw Exception('Failed to load flights');
  }
}


