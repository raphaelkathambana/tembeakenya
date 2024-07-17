import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/model/map_data.dart';
import 'package:tembeakenya/repository/mapbox_requests.dart';
// import 'package:tembeakenya/constants/constants.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);
  var isLight =
      _MapViewState.themeNotifier.value == ThemeMode.light ? true : false;
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-1.3115263, 36.8153588),
    zoom: 11.0,
  );
  MapboxMapController? mapController;
  CameraPosition _position = _kInitialPosition;
  bool _compassEnabled = true;
  bool _myLocationEnabled = true;
  bool _mapExpanded = true;
  bool _isMoving = false;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  late NavigationService navigationService;

  late List<MapData> landmarks;

  @override
  void initState() {
    navigationService = NavigationService(router);
    super.initState();
    fetchLandmarks().then((landmarks) {
      setState(() {
        this.landmarks = landmarks;
      });
    });
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

  @override
  void dispose() {
    mapController?.removeListener(_onMapChanged);
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController!.addListener(_onMapChanged);
    _extractMapInfo();

    mapController!.getTelemetryEnabled().then((isEnabled) => setState(() {
          _telemetryEnabled = isEnabled;
        }));
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Style loaded :)"),
      backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
      duration: const Duration(seconds: 1),
    ));
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

  Widget _myLocationTrackingModeCycler() {
    final MyLocationTrackingMode nextType = MyLocationTrackingMode.values[
        (_myLocationTrackingMode.index + 1) %
            MyLocationTrackingMode.values.length];
    return TextButton(
      child: Text('change to $nextType'),
      onPressed: () {
        setState(() {
          _myLocationTrackingMode = nextType;
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

  Widget _telemetryToggler() {
    return TextButton(
      child: Text('${_telemetryEnabled ? 'disable' : 'enable'} telemetry'),
      onPressed: () {
        setState(() {
          _telemetryEnabled = !_telemetryEnabled;
        });
        mapController?.setTelemetryEnabled(_telemetryEnabled);
      },
    );
  }

  Widget _mapSizeToggler() {
    return TextButton(
      child: Text('${_mapExpanded ? 'shrink' : 'expand'} map'),
      onPressed: () {
        setState(() {
          _mapExpanded = !_mapExpanded;
        });
      },
    );
  }

  Widget _visibleRegionGetter() {
    return TextButton(
      child: const Text('get currently visible region'),
      onPressed: () async {
        var result = await mapController!.getVisibleRegion();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "SW: ${result.southwest.toString()} NE: ${result.northeast.toString()}"),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      styleString: isLight ? MapboxStyles.LIGHT : MapboxStyles.DARK,
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
      onMapCreated: _onMapCreated,
      initialCameraPosition: _kInitialPosition,
      onStyleLoadedCallback: _onStyleLoadedCallback,
      trackCameraPosition: true,
      compassEnabled: _compassEnabled,
      // cameraTargetBounds: _cameraTargetBounds,
      // minMaxZoomPreference: _minMaxZoomPreference,
      // rotateGesturesEnabled: _rotateGesturesEnabled,
      // scrollGesturesEnabled: _scrollGesturesEnabled,
      // tiltGesturesEnabled: _tiltGesturesEnabled,
      // zoomGesturesEnabled: _zoomGesturesEnabled,
      // doubleClickZoomEnabled: _doubleClickToZoomEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onUserLocationUpdated: (location) {
        debugPrint(
            "new location: ${location.position}, alt.: ${location.altitude}, bearing: ${location.bearing}, speed: ${location.speed}, horiz. accuracy: ${location.horizontalAccuracy}, vert. accuracy: ${location.verticalAccuracy}");
      },
      onCameraTrackingDismissed: () {
        setState(() {
          _myLocationTrackingMode = MyLocationTrackingMode.None;
        });
      },
    );
    final List<Widget> listViewChildren = <Widget>[];
    if (mapController != null) {
      listViewChildren.addAll(<Widget>[
        Text('camera bearing: ${_position.bearing}'),
        Text('camera target: ${_position.target.latitude.toStringAsFixed(4)},'
            '${_position.target.longitude.toStringAsFixed(4)}'),
        Text('camera zoom: ${_position.zoom}'),
        Text('camera tilt: ${_position.tilt}'),
        Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
      ]);
      listViewChildren.add(_compassToggler());
      listViewChildren.add(_myLocationToggler());
      listViewChildren.add(_myLocationTrackingModeCycler());
      listViewChildren.add(_mapSizeToggler());
      listViewChildren.add(_telemetryToggler());
      listViewChildren.add(_visibleRegionGetter());
    }
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.swap_horiz),
                onPressed: () => setState(
                  () => isLight = !isLight,
                ),
              ),
              FloatingActionButton(
                child: const Icon(Icons.zoom_in),
                onPressed: () {
                  mapController?.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.zoom_out),
                onPressed: () {
                  mapController?.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.navigation_outlined),
                onPressed: () {
                  navigationService.navigateToNav(context);
                },
              )
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: _mapExpanded ? null : 300.0,
                height: 200.0,
                child: mapboxMap,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                children: listViewChildren,
              ),
            )
          ],
        ));
  }
}
