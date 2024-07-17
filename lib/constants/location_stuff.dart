import 'package:geolocator/geolocator.dart';
import 'package:tembeakenya/main.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:convert';

String currentStyle =
    'mapbox://styles/codeclimberske/clybwemkm00js01pi6ona5ghd';
const mapStyle = 'mapbox://styles/codeclimberske/cly08t734003m01pn9q057kgj';
const navigationStyle =
    'mapbox://styles/codeclimberske/clybwemkm00js01pi6ona5ghd';

LatLng getCurrentLatLngFromSharedPrefs() {
  return LatLng(prefs.getDouble('latitude')!, prefs.getDouble('longitude')!);
}

String getCurrentAddressFromSharedPrefs() {
  return prefs.getString('current-address')!;
}

LatLng getTripLatLngFromSharedPrefs(String type) {
  List sourceLocationList = json.decode(prefs.getString('source')!)['location'];
  List destinationLocationList =
      json.decode(prefs.getString('destination')!)['location'];
  LatLng source = LatLng(sourceLocationList[0], sourceLocationList[1]);
  LatLng destination =
      LatLng(destinationLocationList[0], destinationLocationList[1]);

  if (type == 'source') {
    return source;
  } else {
    return destination;
  }
}

String getSourceAndDestinationPlaceText(String type) {
  String sourceAddress = json.decode(prefs.getString('source')!)['name'];
  String destinationAddress =
      json.decode(prefs.getString('destination')!)['name'];

  if (type == 'source') {
    return sourceAddress;
  } else {
    return destinationAddress;
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  // Get the current user address
  // String currentAddress =
  //     (await getParsedReverseGeocoding(currentPosition.))['place'];

  // Store the user location in sharedPreferences
  var currentPosition = await Geolocator.getCurrentPosition();
  prefs.setDouble('latitude', currentPosition.latitude);
  prefs.setDouble('longitude', currentPosition.longitude);
  // prefs.setString('current-address', currentAddress);
  currentPosition.latitude;
  return currentPosition;
}
