import 'dart:async';
import 'dart:math'; // Import for generating random numbers
import 'dart:convert'; // Import for JSON encoding
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for shared preferences
import 'package:inflights_pro/base/res/styles/app_styles.dart';
import 'package:inflights_pro/services/flight_service.dart';
import 'package:inflights_pro/screens/search/module/airport_map.dart';
import 'package:inflights_pro/screens/tracker/bookmark.dart'; // Import your Bookmark screen

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController departureController = TextEditingController();
  final TextEditingController arrivalController = TextEditingController();
  final FlightService flightService = FlightService();
  Future<List<dynamic>>? flights;

  String? selectedDeparture;
  String? selectedArrival;
  String? selectedAirline;
  List<String> availableAirlines = [];
  bool hasSearched = false;
  bool isLoading = false; // Loading state variable



  void searchFlights() {
    if (selectedDeparture != null && selectedArrival != null) {
      setState(() {
        hasSearched = true;
        selectedAirline = null; // Reset the selected airline
        flights = null; // Reset flights to show loading indicator
        isLoading = true; // Set loading state to true
      });

      flightService.fetchFlights(selectedDeparture!, selectedArrival!).then((result) {
        setState(() {
          flights = Future.value(result); // Assign the fetched flights to the future
          availableAirlines = result
              .map((flight) => flight['airlineIata'] ?? 'N/A')
              .toSet()
              .cast<String>()
              .toList(); // Get available airlines
          isLoading = false; // Set loading state to false
        });
      }).catchError((error) {
        print('Error fetching flights: $error');
        setState(() {
          flights = Future.value([]); // Set flights to an empty list on error
          isLoading = false; // Set loading state to false
        });
      });
    }
  }

  String formatTimeToJakarta(String? timeString) {
    if (timeString == null) return 'N/A'; // Handle null timeString
    DateTime now = DateTime.now();
    DateTime flightTime = DateTime(now.year, now.month, now.day,
        int.parse(timeString.split(':')[0]),
        int.parse(timeString.split(':')[1]));
    final jakartaTimeZone = Duration(hours: 7);
    DateTime jakartaTime = flightTime.toUtc().add(jakartaTimeZone);
    DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(jakartaTime);
  }

  Future<void> saveBookmark(Map<String, dynamic> flight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarks = prefs.getStringList('bookmarks') ?? [];
  
    // Create a new bookmark entry with flight data and the current timestamp
    Map<String, dynamic> bookmarkData = {
      ...flight,
      'timestamp': DateTime.now().toIso8601String(), // Save the current date and time
    };
  
    bookmarks.add(json.encode(bookmarkData)); // Convert flight data to JSON string
    await prefs.setStringList('bookmarks', bookmarks);
    print('Flight saved to bookmarks: ${flight['flightNumber'] ?? 'N/A'}');
  }

  // Estimate price based on flight duration
  String estimatePrice(String? departureTime, String? arrivalTime) {
    if (departureTime == null || arrivalTime == null) return 'N/A';

    DateTime now = DateTime.now();
    DateTime depTime = DateTime(now.year, now.month, now.day,
        int.parse(departureTime.split(':')[0]),
        int.parse(departureTime.split(':')[1]));

    DateTime arrTime = DateTime(now.year, now.month, now.day,
        int.parse(arrivalTime.split(':')[0]),
        int.parse(arrivalTime.split(':')[1]));

    // Adjust arrival time for next day if necessary
    if (arrTime.isBefore(depTime)) {
      arrTime = arrTime.add(Duration(days: 1));
    }

    Duration duration = arrTime.difference(depTime);
    int durationInHours = duration.inHours;

    // Calculate estimated price based on duration
    int basePrice = 925000; // Base price for 1 hour
    int randomVariation = Random().nextInt(50000) + 1; // Random variation between 1 and 50,000
    int estimatedPrice = basePrice + (durationInHours - 1) * 214200 + randomVariation; // Increase price per hour

    // Ensure the price is not negative
    estimatedPrice = estimatedPrice < 0 ? 0 : estimatedPrice;

    return formatRupiah(estimatedPrice); // Return formatted price
  }

  // Format price to Indonesian Rupiah
  String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(amount);
  }

  String getAirlineLogo(String airlineIata) {
    return 'assets/images/maskapai/logo/$airlineIata.png';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Find Flights',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(130, 20, 24, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: const Color.fromARGB(255, 228, 228, 228)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()), // Navigate to bookmark screen
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            height: 45,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Today Flights',
                    textAlign: TextAlign.left,
                    style: AppStyles.headLineStyle1.copyWith(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              children: [
                // Departure TextField
                TextField(
                  controller: departureController,
                  decoration: InputDecoration(
                    hintText: 'Departure',
                    icon: Icon(Icons.flight_takeoff_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Select Departure Airport'),
                          backgroundColor: Colors.white,
                          content: Container(
                            width: double.maxFinite,
                            child: ListView(
                              children: airportMap.entries.map((entry) {
                                return ListTile(
                                  title: Text('${entry.value} (${entry.key})'),
                                  onTap: () {
                                    setState(() {
                                      selectedDeparture = entry.key;
                                      departureController.text = '${entry.value} (${entry.key})';
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
                // Arrival TextField
                TextField(
                  controller: arrivalController,
                  decoration: InputDecoration(
                    hintText: 'Arrival',
                    icon: Icon(Icons.flight_land_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Select Arrival Airport'),
                          backgroundColor: Colors.white,
                          content: Container(
                            width: double.maxFinite,
                            child: ListView(
                              children: airportMap.entries.map((entry) {
                                return ListTile(
                                  title: Text('${entry.value} (${entry.key})'),
                                  onTap: () {
                                    setState(() {
                                      selectedArrival = entry.key;
                                      arrivalController.text = '${entry.value} (${entry.key})';
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(130, 20, 24, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: searchFlights,
                  child: Text('Find Flights'),
                ),
                SizedBox(height: 16),
                // Dropdown for filtering by airline
                if (availableAirlines.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Container(
                        width: 300,
                        child: DropdownButton<String>(
                          hint: Text('Filter by Airline'),
                          value: selectedAirline,
                          onChanged: (value) {
                            setState(() {
                              selectedAirline = value;
                            });
                          },
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: availableAirlines.map((String airline) {
                            return DropdownMenuItem<String>(
                              value: airline,
                              child: Text(airline),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: size.height * 0.5,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : FutureBuilder<List<dynamic>>(
                          future: flights,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (hasSearched) {
                              if (snapshot.data == null || snapshot.data!.isEmpty) {
                                return Center(child: Text('No flights found'));
                              } else {
                                final filteredFlights = snapshot.data!.where((flight) {
                                  if (selectedAirline == null) return true;
                                  return flight['airlineIata'] == selectedAirline;
                                }).toList();

                                if (filteredFlights.isEmpty) {
                                  return Center(child: Text('No flights found for the selected airline'));
                                }

                                return ListView.builder(
                                  itemCount: filteredFlights.length,
                                  itemBuilder: (context, index) {
                                    final flight = filteredFlights[index];
                                    return Card(
                                      color: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      flight['departureIata'] ?? 'N/A',
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      formatTimeToJakarta(flight['departureTime']),
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      flight['arrivalIata'] ?? 'N/A',
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      formatTimeToJakarta(flight['arrivalTime']),
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Terminal: ${flight['departureTerminal'] ?? 'N/A'}',
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 195, 74, 4)),
                                                
                                                ),
                                                Image.asset(
                                                  'assets/images/departure.png',
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                Text(
                                                  estimatePrice(flight['departureTime'], flight['arrivalTime']),
                                                  style: TextStyle(color: const Color.fromARGB(255, 172, 84, 66), fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  getAirlineLogo(flight['airlineIata'] ?? 'default'), // Provide a default if airlineIata is null
                                                  height: 30,
                                                  width: 30,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/maskapai/logo/default.png', // Default logo if not found
                                                      height: 30,
                                                      width: 30,
                                                    );
                                                  },
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '${flight['airlineIata'] ?? 'N/A'} ${flight['flightNumber'] ?? 'N/A'}',
                                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                Spacer(),
                                               IconButton(
  icon: Icon(Icons.bookmark_add, color: const Color.fromARGB(255, 61, 59, 51)),
  onPressed: () {
    // Simpan penerbangan ke bookmark
    saveBookmark(flight); 

    // Tampilkan pesan menggunakan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The flight number has been added to bookmarks'),
      ),
    );
  },
),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
