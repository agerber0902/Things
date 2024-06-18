class ThingLocation{
  final double latitude;
  final double longitude;
  final String address;
  final String? name;

  const ThingLocation({required this.latitude, required this.longitude, required this.address, required this.name});

  factory ThingLocation.fromJson(Map<String, dynamic> json) {
    return ThingLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'name': name,
    };
  }
}