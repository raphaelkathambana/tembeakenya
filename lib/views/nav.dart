import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tembeakenya/assets/colors.dart';
// import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/location_stuff.dart';
import 'package:tembeakenya/main.dart';
import 'package:tembeakenya/repository/mapbox_requests.dart';

class NavigationPage extends StatefulWidget {
  final bool isDestination;
  final TextEditingController textEditingController;
  const NavigationPage(
      {super.key,
      required this.isDestination,
      required this.textEditingController});

  @override
  State<NavigationPage> createState() => _NavigationPageState();

  // Declare a static function to reference setters from children
  static _NavigationPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NavigationPageState>();
}

class _NavigationPageState extends State<NavigationPage> {
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  Timer? searchOnStoppedTyping;
  String query = '';
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  // Define setters to be used by children widgets
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

  @override
  void initState() {
    super.initState();
    // Set initial camera position and current address
    _initialCameraPosition = CameraPosition(
      target: currentLocation,
      zoom: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Add MapboxMap here and enable user location
          MapboxMap(
            initialCameraPosition: _initialCameraPosition,
            accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
            styleString: currentStyle,
            onMapCreated: (controller) async {
              // Set the initial camera position
              controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: currentLocation,
                  zoom: 14.0,
                ),
              ));
            },
            onMapClick: (point, latLng) {
              // Handle map click
            },
            onStyleLoadedCallback: () {
              // Handle style loaded
            },
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.GPS,
            trackCameraPosition: true,
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          'Hi there!',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Select a Location'),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        locationWidget(context),
                                        isLoading
                                            ? const LinearProgressIndicator(
                                                backgroundColor: Colors.white,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white))
                                            : Container(),
                                        isEmptyResponse
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Text(
                                                  hasResponded
                                                      ? noResponse
                                                      : noRequest,
                                                  style: TextStyle(
                                                      color: ColorsUtil
                                                          .textColorDark
                                                          .withOpacity(0.5)),
                                                ),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: responses.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(responses[index]
                                                        ['name']),
                                                    subtitle: Text(
                                                        responses[index]
                                                            ['address']),
                                                    onTap: () {
                                                      // Set the text editing controller to the address
                                                      widget.textEditingController
                                                              .text =
                                                          responses[index]
                                                              ['place'];
                                                      // Set responses and isDestination in parent
                                                      responsesState = [];
                                                      isResponseForDestinationState =
                                                          widget.isDestination;
                                                    },
                                                  );
                                                },
                                              ),
                                        searchListView(
                                            responses,
                                            isResponseForDestination,
                                            destinationController,
                                            sourceController),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Make a request to the Mapbox Search API
                                            // Set isLoading = true in parent
                                            // Set responses and isDestination in parent
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.all(20)),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Search'),
                                            ],
                                          ),
                                        ),
                                      ]),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Ready to Start your Hike?'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onChangeHandler(value) {
    // Set isLoading = true in parent
    isLoadingState = true;

    // Make sure that requests are not made
    // until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    setState(() {
      searchOnStoppedTyping = Timer(const Duration(seconds: 1), () {
        _searchHandler(value);
      });
    });
  }

  _searchHandler(String value) async {
    // Get response using Mapbox Search API
    List response = await getParsedResponseForQuery(value);
    // Set responses and isDestination in parent
    responsesState = response;
    isResponseForDestinationState = widget.isDestination;
    setState(() => query = value);
  }

  _useCurrentLocationButtonHandler() async {
    if (!widget.isDestination) {
      LatLng currentLocation = getCurrentLatLngFromSharedPrefs();

      // Get the response of reverse geocoding and do 2 things:
      // 1. Store encoded response in shared preferences
      // 2. Set the text editing controller to the address
      var response = await getParsedReverseGeocoding(currentLocation);
      prefs.setString('source', json.encode(response));
      widget.textEditingController.text = response['place'];
    }
  }

  Widget locationWidget(BuildContext context) {
    String placeholderText = widget.isDestination ? 'Where to?' : 'Where from?';
    IconData? iconData = !widget.isDestination ? Icons.my_location : null;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: CupertinoTextField(
          controller: widget.textEditingController,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          placeholder: placeholderText,
          placeholderStyle: TextStyle(
            color: ColorsUtil.textColorDark.withOpacity(0.5),
          ),
          decoration: const BoxDecoration(
            color: ColorsUtil.primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          onChanged: _onChangeHandler,
          suffix: IconButton(
              onPressed: () => _useCurrentLocationButtonHandler(),
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
              icon: Icon(iconData, size: 16))),
    );
  }

  Widget searchListView(
      List responses,
      bool isResponseForDestination,
      TextEditingController destinationController,
      TextEditingController sourceController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: responses.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
              onTap: () {},
              leading: const SizedBox(
                height: double.infinity,
                child: CircleAvatar(child: Icon(Icons.map)),
              ),
              title: Text(responses[index]['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(responses[index]['address'],
                  overflow: TextOverflow.ellipsis),
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  Future<List> getParsedResponseForQuery(String value) async {
    List parsedResponses = [];

    // If empty query send blank response
    String query = getValidatedQueryFromQuery(value);
    if (query == '') return parsedResponses;

    // Else search and then send response
    var response =
        json.decode(await getSearchResultsFromQueryUsingMapbox(query));

    List features = response['features'];
    for (var feature in features) {
      Map response = {
        'name': feature['text'],
        'address': feature['place_name'].split('${feature['text']}, ')[1],
        'place': feature['place_name'],
        'location': LatLng(feature['center'][1], feature['center'][0])
      };
      parsedResponses.add(response);
    }
    return parsedResponses;
  }

// ----------------------------- Mapbox Reverse Geocoding -----------------------------
  Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
    var response =
        json.decode(await getReverseGeocodingGivenLatLngUsingMapbox(latLng));
    Map feature = response['features'][0];
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latLng
    };
    return revGeocode;
  }

  String getValidatedQueryFromQuery(String value) {
    return '';
  }
}
