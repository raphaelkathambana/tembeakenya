import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tembeakenya/assets/colors.dart';

import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/constants/location_stuff.dart';
import 'package:tembeakenya/model/map_data.dart';

class NavigationView extends StatefulWidget {
  final bool isDestination;
  final TextEditingController textEditingController;
  const NavigationView(
      {super.key,
      required this.isDestination,
      required this.textEditingController});

  @override
  State<NavigationView> createState() => _NavigationViewState();

  static _NavigationViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NavigationViewState>();
}

class _NavigationViewState extends State<NavigationView> {
  MapboxMapController? mapController;
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  Timer? searchOnStoppedTyping;
  String query = '';
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  late List<MapData> landmarks;
  List<LatLng> _userPath = [];
  bool _isNavigating = false;
  bool _isPaused = false;
  DateTime? _startTime;
  double _distanceWalked = 0.0;
  StreamSubscription<Position>? _positionStream;
  Duration _duration = Duration.zero;
  late List<Symbol> symbols;

  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Style loaded :)"),
      backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
      duration: const Duration(seconds: 1),
    ));
    _addLandmarkMarkers();
  }

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-1.3115263, 36.8153588),
    zoom: 11.0,
  );

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: currentLocation,
      zoom: 14.0,
    );
    fetchLandmarks().then((landmarks) {
      setState(() {
        this.landmarks = landmarks;
        _addLandmarkMarkers();
      });
    }).catchError((error) {
      debugPrint('Failed to fetch landmarks: $error');
    });
  }

  Future<List<MapData>> fetchLandmarks() async {
    try {
      final response = await APICall().client.get('${url}api/landmarks');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;
        return jsonResponse
            .map((landmark) => MapData.fromJson(landmark))
            .toList();
      } else {
        throw Exception('Failed to load landmarks');
      }
    } on DioException catch (e) {
      debugPrint('Failed to load landmarks: $e');
      throw Exception('Failed to load landmarks');
    }
  }

  void _addLandmarkMarkers() {
    Map<String, MapData> symbolLandmarkMap = {};

    for (var landmark in landmarks) {
      mapController!
          .addSymbol(SymbolOptions(
        geometry: LatLng(landmark.latitude, landmark.longitude),
        iconImage: 'mountain-15',
      ))
          .then((symbol) {
        symbolLandmarkMap[symbol.id] =
            landmark; // Associate symbol with landmark
        mapController!.onSymbolTapped.add((tappedSymbol) {
          if (symbol.id == tappedSymbol.id) {
            _showLandmarkDetails(landmark);
          }
        });
      });
    }
  }

  void _showLandmarkDetails(MapData landmark) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(landmark.name),
              subtitle: Text(landmark.description),
              onTap: () {
                // Close the modal
                Navigator.pop(context);
                // Start walking navigation
                _startWalkingNavigation(landmark);
              },
            ),
            ListTile(
              title: const Text('Navigate to Starting Point'),
              onTap: () {
                // Close the modal
                Navigator.pop(context);
                // Start driving navigation
                _startDrivingNavigation(landmark);
              },
            ),
          ],
        );
      },
    );
  }

  void _startWalkingNavigation(MapData landmark) async {
    try {
      final response = await APICall().client.post(
            '${url}api/hikes/${landmark.id}/route',
            data: jsonEncode({
              'navigation_mode': 'walking',
            }),
            options: Options(headers: {
              'Content-Type': 'application/json',
            }),
          );

      if (response.statusCode == 200) {
        final route = response.data['route'];
        debugPrint('Route received: $route');

        if (route != null &&
            route['routes'] != null &&
            route['routes'].isNotEmpty) {
          _startNavigation(route['routes'][0]);
          setState(() {
            _isNavigating = true;
          });
        } else {
          debugPrint('No routes found in the response');
        }
      } else {
        debugPrint('Failed to load route: ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('Error occurred: $e');
    }
  }

  void _startDrivingNavigation(MapData landmark) async {
    final userLocation = await Geolocator.getCurrentPosition();

    try {
      final response = await APICall().client.post(
            '${url}api/hikes/${landmark.id}/route',
            data: jsonEncode({
              'latitude': userLocation.latitude.toString(),
              'longitude': userLocation.longitude.toString(),
              'navigation_mode': 'driving',
            }),
            options: Options(headers: {
              'Content-Type': 'application/json',
            }),
          );

      if (response.statusCode == 200) {
        final route = response.data['route'];
        // debugPrint('Route received: $route');

        if (route != null &&
            route['routes'] != null &&
            route['routes'].isNotEmpty) {
          final duration = route['routes'][0]['duration'];
          final distance = route['routes'][0]['distance'];
          _showDrivingStats(duration, distance);
          _startNavigation(route['routes'][0]);
          setState(() {
            _isNavigating = true;
          });
        } else {
          debugPrint('No routes found in the response');
        }
      } else {
        debugPrint('Failed to load route: ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('Error occurred: $e');
    }
  }

  void _startNavigation(Map<String, dynamic> route) {
    List<LatLng> routeCoordinates = (route['geometry']['coordinates'] as List)
        .map((coord) => LatLng(coord[1], coord[0]))
        .toList();

    mapController!.addLine(LineOptions(
      geometry: routeCoordinates,
      lineColor: "#ff0000",
      lineWidth: 5.0,
    ));

    Geolocator.getPositionStream().listen((Position position) {
      mapController!
          .updateMyLocationTrackingMode(MyLocationTrackingMode.Tracking);
    });
  }

  void _showDrivingStats(double duration, distance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Driving Stats'),
          content: Text(
              'Estimated Time: ${Duration(seconds: duration.toInt()).inHours}:${Duration(seconds: duration.toInt()).inMinutes % 60}:${duration.toInt() % 60}\nDistance: ${(distance / 1000).toStringAsFixed(2)} km'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startInstantNavigation() async {
    if (_isNavigating) {
      _pauseOrResumeNavigation();
    } else {
      _startTime = DateTime.now();
      _userPath.clear();
      _distanceWalked = 0.0;
      _isNavigating = true;
      _isPaused = false;

      final userLocation = await Geolocator.getCurrentPosition();
      _userPath.add(LatLng(userLocation.latitude, userLocation.longitude));

      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 16.0,
          tilt: 45.0,
        ),
      ));

      _positionStream =
          Geolocator.getPositionStream().listen((Position position) {
        if (_isPaused) return;

        final newPosition = LatLng(position.latitude, position.longitude);
        _userPath.add(newPosition);

        if (_userPath.length > 1) {
          _distanceWalked += Geolocator.distanceBetween(
            _userPath[_userPath.length - 2].latitude,
            _userPath[_userPath.length - 2].longitude,
            newPosition.latitude,
            newPosition.longitude,
          );
        }

        setState(() {
          _duration = DateTime.now().difference(_startTime!);
        });

        mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: 16.0,
            tilt: 45.0,
          ),
        ));

        mapController!.clearLines();
        mapController!.addLine(LineOptions(
          geometry: _userPath,
          lineColor: "#ff0000",
          lineWidth: 5.0,
        ));
      });
    }
  }

  void _pauseOrResumeNavigation() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopNavigation() {
    _positionStream?.cancel();
    _isNavigating = false;
    // remove navigation markings

    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);
    final distanceKm = (_distanceWalked / 1000).toStringAsFixed(2);
    final durationString =
        '${duration.inHours}:${duration.inMinutes % 60}:${duration.inSeconds % 60}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Navigation Stats'),
          content: Text(
              'Distance: $distanceKm km\nDuration: $durationString\nSteps: ${_distanceWalked ~/ 0.75}'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentLocation,
        zoom: 14.0,
        tilt: 0.0,
      ),
    ));
  }

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

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController!.addListener(_onMapChanged);
    _extractMapInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            initialCameraPosition: _initialCameraPosition,
            accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
            styleString: MapboxStyles.OUTDOORS,
            onMapCreated: _onMapCreated,
            onMapClick: (point, latLng) {
              // Handle map click
            },
            onStyleLoadedCallback: _onStyleLoadedCallback,
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.GPS,
            trackCameraPosition: true,
          ),
          if (_isNavigating)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: NavigationStats(
                distance: _distanceWalked,
                duration: _duration,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isNavigating ? _stopNavigation : _startInstantNavigation,
        child: Icon(_isNavigating ? Icons.stop : Icons.navigation),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _isNavigating
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 4.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    onPressed: _pauseOrResumeNavigation,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class NavigationStats extends StatelessWidget {
  final double distance;
  final Duration duration;

  const NavigationStats({
    super.key,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final distanceKm = (distance / 1000).toStringAsFixed(2);
    final durationString =
        '${duration.inHours}:${duration.inMinutes % 60}:${duration.inSeconds % 60}';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Distance: $distanceKm km',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'Duration: $durationString',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
