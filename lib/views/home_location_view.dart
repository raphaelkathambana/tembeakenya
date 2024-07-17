import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/dummy_db_3.dart';
import 'package:tembeakenya/assets/colors.dart';
// import 'package:tembeakenya/model/user_model.dart';

class HomeLocationView extends StatefulWidget {
  final dynamic user;
  final dynamic location;
  final dynamic reviews;
  const HomeLocationView({
    super.key,
    required this.user,
    required this.location,
    required this.reviews,
  });

  @override
  State<HomeLocationView> createState() => _HomeLocationViewState();
}
// Pic
// name
// distance and duration
// reviews
// button to nav ?????
//

class _HomeLocationViewState extends State<HomeLocationView> {
  late int hID;
  int distance = 1000;
  String duration = '2024-07-17T00:25:13.000000Z';

  String displayUrl = '';
  List<String> groupFilter = <String>['All Groups', 'My Groups'];
  late NavigationService navigationService;

  String profileImageID = "";
  late int loadNum;

  @override
  void initState() {
    navigationService = NavigationService(router);
    hID = widget.location[0];
    // loadNum = reviews.length;
    loadNum = 10;

    for (int i = 0; i < location.length; i++) {
      profileImageID = widget.location[5];
      getImageUrl(profileImageID).then((String result) {
        setState(() {
          displayUrl = result;
        });
      });
    }

    super.initState();
  }

  reviewCard(int num) {
    dynamic firstName = widget.reviews.entries.first.value[num]['user']['firstName'];
    dynamic lastName = widget.reviews.entries.first.value[num]['user']['lastName'];
    dynamic username = widget.reviews.entries.first.value[num]['user']['username'];
    dynamic review = widget.reviews.entries.first.value[num]['review'];
    dynamic hikeId = widget.reviews.entries.first.value[num]['hike_id'];

    if (hikeId == hID){   
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
      decoration: BoxDecoration(
        color: ColorsUtil.cardColorDark,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: ColorsUtil.accentColorDark),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          '$firstName $lastName',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: ColorsUtil.textColorDark),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.only(
                            bottom: 0, left: 10, right: 10),
                        child: Text(
                          '@$username',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.accentColorDark),
                        ),
                      ),
                      Container(
                        height: 125,
                        margin: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 7),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: ColorsUtil.descriptionColorDark,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: ColorsUtil.accentColorDark),
                        ),
                        child: Text(
                          review,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.textColorDark),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {

    dynamic name = widget.location[1];
    dynamic waypoints = widget.location[2];
    dynamic distance = widget.location[3];
    dynamic duration = widget.location[4];
    
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Location Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        body:
            Stack(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: ColorsUtil.secondaryColorDark),
              color: ColorsUtil.cardColorDark,
            ),
            // height: 360,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Column(children: [
              if (displayUrl.isEmpty)
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width * .9,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorsUtil.backgroundColorDark),
                      // color: Colors.amber,
                      image: DecorationImage(
                        image: NetworkImage(displayUrl),
                        fit: BoxFit.cover,
                      )),
                ),
              const Divider(
                height: 2,
                color: ColorsUtil.accentColorDark,
                indent: 12,
                endIndent: 12,
              ),
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  // height: 110,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                    color: ColorsUtil.descriptionColorDark,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$name',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.textColorDark)),
                      Text('Distance: ${distance}m',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.primaryColorDark)),
                      Text('Estimated Duration: $duration',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.primaryColorDark)),
                    ],
                  )),
              // Container(
              //   margin: const EdgeInsets.all(7),
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       color: ColorsUtil.descriptionColorDark,
              //       border: Border.all(color: ColorsUtil.backgroundColorDark),
              //       borderRadius: BorderRadius.circular(10)),
              //   child: const Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('Statistics',
              //             style: TextStyle(
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //                 color: ColorsUtil.primaryColorDark)),
              //         Divider(
              //           height: 15,
              //           color: ColorsUtil.secondaryColorDark,
              //         ),
              //         Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text('Distance',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         fontWeight: FontWeight.normal,
              //                         color: ColorsUtil.primaryColorDark)),
              //                 Row(
              //                     crossAxisAlignment: CrossAxisAlignment.end,
              //                     children: [
              //                       Text("0",
              //                           style: TextStyle(
              //                               fontSize: 30,
              //                               fontWeight: FontWeight.normal,
              //                               color: ColorsUtil.textColorDark)),
              //                       Text(' m',
              //                           style: TextStyle(
              //                               height: 2,
              //                               fontSize: 15,
              //                               fontWeight: FontWeight.normal,
              //                               color: ColorsUtil.textColorDark)),
              //                     ]),
              //                 Text('Duration',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         fontWeight: FontWeight.normal,
              //                         color: ColorsUtil.primaryColorDark)),
              //                 Row(
              //                     // mainAxisAlignment: MainAxisAlignment.end,
              //                     crossAxisAlignment: CrossAxisAlignment.end,
              //                     children: [
              //                       Text("2",
              //                           style: TextStyle(
              //                               fontSize: 30,
              //                               fontWeight: FontWeight.normal,
              //                               color: ColorsUtil.textColorDark)),
              //                       Text(' h',
              //                           style: TextStyle(
              //                               height: 2,
              //                               fontSize: 15,
              //                               fontWeight: FontWeight.normal,
              //                               color: ColorsUtil.textColorDark)),
              //                       Text(" 30",
              //                           style: TextStyle(
              //                               fontSize: 30,
              //                               fontWeight: FontWeight.normal,
              //                               color: ColorsUtil.textColorDark)),
              //                       Text(' m',
              //                           style: TextStyle(
              //                               height: 2,
              //                               fontSize: 15,
              //                               fontWeight: FontWeight.normal,
              //                               color: ColorsUtil.textColorDark)),
              //                     ]),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ]),
              // ),
            ]),
          ),
          DraggableScrollableSheet(
            initialChildSize: 90 / width,
            minChildSize: 90 / width,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                // height: 0.25,
                width: width,
                decoration: BoxDecoration(
                  color: ColorsUtil.descriptionColorDark,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border.all(
                      color: ColorsUtil.backgroundColorDark, width: 1.5),
                ),

                // *********************************************************** //

                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 15),
                      height: 5,
                      child: const Icon(
                        Icons.maximize_rounded,
                        color: Color.fromARGB(112, 99, 126, 32),
                        size: 60,
                      ),
                    ),
                    Container(
                      // width: width,
                      margin: const EdgeInsets.all(25),
                      child: const Text(
                        'Reviews From Hikers',
                        style: TextStyle(
                            color: ColorsUtil.primaryColorDark,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      height: 15,
                      color: ColorsUtil.accentColorDark,
                    ),
                    for (int i = 0; i < loadNum; i++) reviewCard(i),
                  ],
                ),
              );
            },
          )
        ])
        // ),
        );
  }
}
