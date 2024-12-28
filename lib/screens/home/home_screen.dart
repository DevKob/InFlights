import 'package:flutter/material.dart';
import 'package:inflights_pro/base/res/styles/app_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:inflights_pro/services/flight_service.dart'; // Import your flight service

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> airports = [];
  List<dynamic> filteredAirports = [];
  List<dynamic> flights = []; // List to hold flight data
  FlightService flightService = FlightService(); // Instantiate FlightService

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    fetchAirports();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAirports() async {
    final response = await http.get(Uri.parse(
        'https://aviation-edge.com/v2/public/airportDatabase?key=ac813a-a5c9ec&codeIso2Country=ID'));
    if (response.statusCode == 200) {
      setState(() {
        airports = json.decode(response.body);
        filteredAirports = airports;
      });
    } else {
      throw Exception('Failed to load airports');
    }
  }

  void filterAirports(String query) {
    final filtered = airports.where((airport) {
      final name = airport['nameAirport']?.toLowerCase() ?? '';
      final code = airport['codeIataCity']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) ||
          code.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredAirports = filtered;
    });
  }

  void _launchMapsUrl(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void updateSearch(String code) {
    _searchController.text = code;
    filterAirports(code);
    fetchFlights(code); // Fetch flights when an airport is selected
  }

  Future<void> fetchFlights(String departureIata) async {
    try {
      final response = await flightService.fetchFlights(departureIata, "CGK"); // Example arrival IATA
      if (response.isNotEmpty) {
        setState(() {
          flights = response; // Update flights list
        });
      } else {
        setState(() {
          flights = []; // Clear flights if no data is returned
        });
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching flights: $e');
      setState(() {
        flights = []; // Clear flights on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
          'Domestic Airport',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(130, 20, 24, 1),
      ),
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                  const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 600),
                  child: ClipRect(
                    child: Image.asset(
                      'assets/images/imaps.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          // Flight Swipe Navigation
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 10,
            right: 10,
            child: flights.isNotEmpty
                ? SizedBox(
                    height: 140, // Atur tinggi sesuai kebutuhan
                    child: buildFlightSwipe(),
                  )
                : Center(child: Text('No flights available')),
          ),
          // Create Points
          Stack(
            children: [
              createPoint(top: 35.0, left: -5.0, code: 'BTJ'),
              createPoint(top: 55.0, left: 25.0, code: 'MES'),
              createPoint(top: 74.0, left: 55.0, code: 'PKU'),
              createPoint(top: 86.0, left: 35.0, code: 'PDG'),
              createPoint(top: 102.0, left: 55.0, code: 'BKS'),
              createPoint(top: 105.0, left: 75.0, code: 'PLM'),
              createPoint(top: 100.0, left: 86.0, code: 'PGK'),
              createPoint(top: 120.0, left: 76.0, code: 'TGK'),
              createPoint(top: 135.0, left: 95.8, code: 'JKT'),
              createPoint(top: 140.0, left: 105.8, code: 'BDO'),
              createPoint(top: 140.0, left: 120.8, code: 'SRG'),
              createPoint(top: 147.0, left: 115.8, code: 'JOG'),
              createPoint(top: 140.0, left: 140.8, code: 'SUB'),
              createPoint(top: 155.0, left: 165.8, code: 'DPS'),
              createPoint(top: 155.0, left: 175.8, code: 'LOP'),
              createPoint(top: 155.0, left: 220.8, code: 'TMC'),
              createPoint(top: 168.0, left: 245.8, code: 'WGP'),
              createPoint(top: 110.0, left: 285.8, code: 'AMQ'),
              createPoint(top: 90.0, left: 315.8, code: 'DJJ'),
              createPoint(top: 90.0, left: 350.8, code: 'MKW'),
              createPoint(top: 110.0, left: 380.8, code: 'DJJ'),
              createPoint(top: 155.0, left: 390.8, code: 'DJJ'),
              createPoint(top: 68.0, left: 253.8, code: 'MDC'),
              createPoint(top: 75.0, left: 230.8, code: 'GTO'),
              createPoint(top: 90.0, left: 207.8, code: 'PLW'),
              createPoint(top: 120.0, left: 204.8, code: 'UPG'),
              createPoint(top: 115.0, left: 225.8, code: 'KDI'),
              createPoint(top: 110.0, left: 160.8, code: 'BDJ'),
              createPoint(top: 50.0, left: 180.8, code: 'TRK'),
              createPoint(top: 90.0, left: 150.8, code: 'PKY'),
              createPoint(top: 85.0, left: 120.8, code: 'PTK'),
            ],
          ),
          // Search Box and Airport List
          Positioned.fill(
            top: MediaQuery.of(context).size.height *
                0.45, // Adjust to position below the image and swipe navigation
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.30),
                  child: TextField(
                    controller: _searchController,
                    onChanged: filterAirports,
                    decoration: InputDecoration(
                      hintText: 'Search Airports',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 254, 254),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredAirports.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredAirports.length,
                          itemBuilder: (context, index) {
                            final airport = filteredAirports[index];
                            return createLocation(
                              code: airport['codeIataCity'] ?? 'N/A',
                              icao: airport['codeIcaoAirport'] ?? 'N/A',
                              name: airport['nameAirport'] ?? 'N/A',
                              gmt: airport['GMT'] ?? 'N/A',
                              timezone: airport['timezone'] ?? 'N/A',
                              latitude: airport['latitudeAirport'] ?? 0.0,
                              longitude: airport['longitudeAirport'] ?? 0.0,
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createPoint(
      {required double top, required double left, String? code}) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          if (code != null) {
            updateSearch(code);
          }
        },
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(130, 20, 24, 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createLocation({
    required String code,
    required String icao,
    required String name,
    required String gmt,
    required String timezone,
    required double latitude,
    required double longitude,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            'IATA City Code: $code',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
          Text(
            'Airport Code: $icao',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
          Text(
            'GMT: +$gmt ($timezone)',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              _launchMapsUrl(latitude, longitude);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(130, 20, 24, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.map, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'View Maps',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFlightSwipe() {
    return Container(
      height: 100, // Height for the swipeable area
      child: flights.isNotEmpty
          ? PageView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                String airlineIata = flight['airlineIata'] ?? 'default';
                String logoPath = 'assets/images/maskapai/logo/$airlineIata.png';
                String defaultLogoPath = 'assets/images/maskapai/logo/default.png';

                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                  '${flight['departureIata'] ?? 'N/A'}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                ),
                                Text(
                                  '${flight['departureTime'] ?? 'N/A'}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Image.asset(
                              logoPath,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  defaultLogoPath,
                                  width: 50,
                                  height: 50,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Arrival: ${flight['arrivalIata'] ?? 'N/A'} at ${flight['arrivalTime'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Flight Number: ${flight['airlineIata'] ?? 'N/A'} ${flight['flightNumber'] ?? 'N/A'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('No flights available')), // Handle empty flights
    );
  }
}
