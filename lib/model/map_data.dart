// import 'package:tembeakenya/constants/constants.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapData {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final List<LatLng> waypoints;

  MapData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.waypoints,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      description: json['description'],
      waypoints: (json['waypoints'] as List)
          .map((waypoint) => LatLng(
              double.parse(waypoint['latitude'].toString()),
              double.parse(waypoint['longitude'].toString())))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'waypoints': waypoints
          .map((waypoint) =>
              {'latitude': waypoint.latitude, 'longitude': waypoint.longitude})
          .toList(),
    };
  }
}
