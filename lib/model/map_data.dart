import 'package:tembeakenya/constants/constants.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

Future<List<MapData>> fetchLandmarks() async {
  final response = await APICall().client.get('${url}api/landmarks');

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = response.data;
    return jsonResponse.map((landmark) => MapData.fromJson(landmark)).toList();
  } else {
    throw Exception('Failed to load landmarks');
  }
}

class MapData {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String image;
  final List<LatLng> waypoints;

  MapData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.image,
    required this.waypoints,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      description: json['description'],
      image: json['image'],
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
      'image': image,
      'waypoints': waypoints
          .map((waypoint) =>
              {'latitude': waypoint.latitude, 'longitude': waypoint.longitude})
          .toList(),
    };
  }
}
