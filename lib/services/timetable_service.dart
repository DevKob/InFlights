import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimetableService {
  final String apiKey = 'ac813a-a5c9ec';

  Future<List<dynamic>> fetchTimetable(String departureIata) async {
    final url = Uri.parse(
        'https://aviation-edge.com/v2/public/timetable?iataCode=$departureIata&type=departure&key=$apiKey');

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
      throw Exception('Failed to load flight timetable: ${response.statusCode} ${response.body}');
    }
  }
}
