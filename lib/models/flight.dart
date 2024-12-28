class Flight {
  final String flightNumber;
  final double latitude;
  final double longitude;

  Flight({required this.flightNumber, required this.latitude, required this.longitude});

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNumber: json['flight']['iataNumber'],
      latitude: json['geography']['latitude'],
      longitude: json['geography']['longitude'],
    );
  }
}
