import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/model/map_data.dart';

// void _onLandmarkTapped(MapData landmark) async {
//   final userLocation = await Geolocator.getCurrentPosition();

//   final response = await APICall().client.get(
//     '${url}api/hikes/${landmark.id}/route',
//     data: {
//       'latitude': userLocation.latitude.toString(),
//       'longitude': userLocation.longitude.toString(),
//     },
//   );

//   if (response.statusCode == 200) {
//     final route = json.decode(response.data)['route'];
//     _startNavigation(route);
//   } else {
//     // Handle error
//   }
// }

// void _onLandmarkTapped(MapData landmark) async {
//   final userLocation = await Geolocator.getCurrentPosition();

//   final response = await http.post(
//     Uri.parse('https://yourapi.com/hikes/${landmark.id}/route'),
//     body: {
//       'latitude': userLocation.latitude.toString(),
//       'longitude': userLocation.longitude.toString(),
//     },
//   );

//   if (response.statusCode == 200) {
//     final route = json.decode(response.body)['route'];
//     _startNavigation(route);
//   } else {
//     // Handle error
//   }
// }
