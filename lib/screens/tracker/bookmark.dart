import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Map<String, dynamic>> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarks') ?? [];
    
    // Parse the saved bookmarks into a list of maps
    bookmarks = savedBookmarks.map((flightString) {
      // Assuming flightString is formatted as a JSON string
      return Map<String, dynamic>.from(json.decode(flightString));
    }).toList();
    
    setState(() {});
  }

  Future<void> removeBookmark(String flightString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarks.removeWhere((flight) => flight.toString() == flightString);
    await prefs.setStringList('bookmarks', bookmarks.map((flight) => json.encode(flight)).toList());
    setState(() {});
  }

  String getAirlineLogo(String airlineIata) {
    return 'assets/images/maskapai/logo/$airlineIata.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks',
         style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(130, 20, 24, 1),
      ),
      body: Container(
        color: Colors.grey[200], // Light gray background color
        child: bookmarks.isEmpty
            ? Center(child: Text('No bookmarks found'))
            : ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final flight = bookmarks[index];
                  final airlineIata = flight['airlineIata'] ?? 'N/A';
                  final flightNumber = flight['flightNumber'] ?? 'N/A';
                  final departureIata = flight['departureIata'] ?? 'N/A';
                  final arrivalIata = flight['arrivalIata'] ?? 'N/A';
                  final timestamp = flight['timestamp'] ?? 'N/A'; // Get the timestamp

                  // Parse the timestamp to a DateTime object
                  final dateTime = DateTime.parse(timestamp);
                  final formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}"; // Format date
                  final formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}"; // Format time

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white, // White background for the card
                    child: ListTile(
                      leading: Image.asset(
                        getAirlineLogo(airlineIata),
                        height: 40,
                        width: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/maskapai/logo/default.png', // Default logo if not found
                            height: 40,
                            width: 40,
                          );
                        },
                      ),
                      title: Text(
                        '$airlineIata $flightNumber',
                        style: TextStyle(fontWeight: FontWeight.bold), // Make text bold
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flight_takeoff, size: 16, color: Colors.blue), // Departure icon
                              SizedBox(width: 4), // Space between the icon and text
                              Text('$departureIata'),
                              SizedBox(width: 10), // Space between departure and arrival
                              Icon(Icons.flight_land, size: 16, color: Colors.green), // Arrival icon
                              SizedBox(width: 4), // Space between the icon and text
                              Text('$arrivalIata'),
                            ],
                          ),
                          SizedBox(height: 4), // Space between flight info and timestamp
                          Text('Saved on: $formattedDate at $formattedTime'), // Display the saved date and time
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.bookmark_remove, color: const Color.fromARGB(255, 163, 24, 14)),
                        onPressed: () {
                          removeBookmark(flight.toString()); // Remove bookmark
                            // Tampilkan pesan menggunakan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The flight has been removed from bookmarks'),
      ),
    );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
