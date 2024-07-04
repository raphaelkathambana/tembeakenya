import 'package:flutter/material.dart';
// import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
// import 'package:tembeakenya/constants/constants.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  LatLng? latLng;
  late MapboxMapController mapboxMapController;
  late CameraPosition _initialCameraPosition;

  Future<LatLng> getLatLngFromSharedPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return LatLng(sharedPreferences.getDouble('latitude')!,
        sharedPreferences.getDouble('longitude')!);
  }

  @override
  void initState() {
    getLatLngFromSharedPrefs().then((value) {
      setState(() {
        latLng = value;
      });
    });
    _initialCameraPosition = CameraPosition(
      target: latLng != null ? latLng! : const LatLng(-1.3115263, 36.8153588),
      zoom: 14,
    );
    super.initState();
  }

  _onMapCreated(MapboxMapController controller) async {
    mapboxMapController = controller;
  }

  _styleLoadedCallback() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorsUtil.backgroundColorDark,
        title: const Text('Map',
            style: TextStyle(
              color: ColorsUtil.primaryColorLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Text('$latLng?.latitude, $latLng?.longitude'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: MapboxMap(
                accessToken: accessToken,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                // onStyleLoadedCallback: _styleLoadedCallback,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
              ),
            )
          ],
        ),
        // child: MapboxMap(
        //   accessToken: accessToken,
        //   styleString: MapboxStyles.LIGHT,
        //   initialCameraPosition: CameraPosition(
        //     target: latLng!,
        //     zoom: 14,
        //   ),
        //   onMapCreated: (MapboxMapController controller) async {
        //     controller.addSymbol(SymbolOptions(
        //       geometry: latLng,
        //       iconImage: 'airport-15',
        //       textField: 'You are here',
        //     ));
        //   },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapboxMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(
          Icons.my_location,
          color: ColorsUtil.primaryColorLight,
        ),
      ),
    );
  }
}
