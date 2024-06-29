import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tembeakenya/constants/consts.dart';
import 'package:tembeakenya/model/user_model.dart';
import 'package:location/location.dart';

class NavigationPage extends StatefulWidget {
  final User user;
  const NavigationPage({super.key, required this.user});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  MapboxMapController? mapController;
  bool _myLocationEnabled = true;
  int _styleStringIndex = 0;
  bool _compassEnabled = true;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;

  List<String> _styleStrings = [
    MapboxStyles.MAPBOX_STREETS,
    MapboxStyles.SATELLITE,
    "assets/style.json"
  ];
  List<String> _styleStringLabels = [
    "MAPBOX_STREETS",
    "SATELLITE",
    "LOCAL_ASSET"
  ];

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    final position = mapController!.cameraPosition;
    if (position != null) _position = position;
    _isMoving = mapController!.isCameraMoving;
  }

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11.0,
  );

  void checkLocationPermission() async {
    final location = Location();
    final hasPermissions = await location.hasPermission();
    if (hasPermissions != PermissionStatus.granted) {
      await location.requestPermission();
    }
  }

  Widget _setStyleToSatellite() {
    return TextButton(
      child: Text(
          'change map style to ${_styleStringLabels[(_styleStringIndex + 1) % _styleStringLabels.length]}'),
      onPressed: () {
        setState(() {
          _styleStringIndex = (_styleStringIndex + 1) % _styleStrings.length;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return TextButton(
      child: Text('${_myLocationEnabled ? 'disable' : 'enable'} my location'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _compassToggler() {
    return TextButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compasss'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listViewChildren = <Widget>[];
    if (mapController != null) {
      listViewChildren.addAll(
        <Widget>[
          Text('camera bearing: ${_position.bearing}'),
          Text('camera target: ${_position.target.latitude.toStringAsFixed(4)},'
              '${_position.target.longitude.toStringAsFixed(4)}'),
          Text('camera zoom: ${_position.zoom}'),
          Text('camera tilt: ${_position.tilt}'),
          Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
          _compassToggler(),
          _setStyleToSatellite(),
          _myLocationToggler(),
        ],
      );
    }
    return MapboxMap(
      accessToken: mapboxApiToken,
      initialCameraPosition: _kInitialPosition,
      myLocationEnabled: _myLocationEnabled,
      styleString: _styleStrings[_styleStringIndex],
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController!.addListener(_onMapChanged);
    _extractMapInfo();
  }
}
