import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FlightService {
  final String apiKey = 'ac813a-a5c9ec';

  Future<List<dynamic>> fetchFlights(String departure, String arrival) async {
    final url = Uri.parse(
        'https://aviation-edge.com/v2/public/routes?key=$apiKey&departureIata=$departure&arrivalIata=$arrival');

    final response = await http.get(url);

    if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if the response is a List or a Map
        if (data is List) {
            return data; // Return the entire response as a list
        } else if (data is Map) {
            return [data]; // Wrap the single object in a list
        } else {
            return []; // Return an empty list if the data is neither
        }
    } else {
        throw Exception('Failed to load flight data: ${response.statusCode} ${response.body}');
    }
}


  Future<List<dynamic>> fetchAirports() async {
    final url = Uri.parse(
        'https://aviation-edge.com/v2/public/airportDatabase?key=$apiKey&codeIso2Country=ID');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Return the entire response
    } else {
      throw Exception('Failed to load airport data: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<dynamic>> fetchFutureFlights(String iataCode) async {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7)));
    final url = Uri.parse('https://aviation-edge.com/v2/public/flightsFuture?key=$apiKey&iataCode=$iataCode&type=departure&date=$date');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data is List ? data : [data]; // Return the list of future flights
    } else {
      throw Exception('Failed to load future flight data: ${response.statusCode} ${response.body}');
    }
  }


Future<List<dynamic>> fetchFlightHistory(String airlineIata, String flightNumber, String departureIata, String dateFrom) async {
  final url = Uri.parse(
    'https://aviation-edge.com/v2/public/flightsHistory?key=$apiKey&code=$departureIata&airline_iata=$airlineIata&flight_num=$flightNumber&date_from=$dateFrom&type=departure'
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data is List ? data : [data]; // Return the list of flight history
  } else {
    throw Exception('Failed to load flight history: ${response.statusCode} ${response.body}');
  }
}





  Future<List<dynamic>> fetchAllFlights() async {
    final url = Uri.parse('https://aviation-edge.com/v2/public/routes?key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Return the entire response
    } else {
      throw Exception('Failed to load all flight data: ${response.statusCode} ${response.body}');
    }
  }


}

