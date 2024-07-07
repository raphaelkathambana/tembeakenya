// group_event_view

import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/views/people_detail_view.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

// ******************* DUMMY DATABASE ******************* //
import 'package:tembeakenya/dummy_db.dart';

class GroupEventView extends StatefulWidget {
  final int userID;
  const GroupEventView({super.key, required this.userID});

  @override
  State<GroupEventView> createState() => _GroupEventViewState();
}

class _GroupEventViewState extends State<GroupEventView> {
  late String displayUrl;
  late int uID;

  int loadNum = fullName.length;

  String theGroupName = '';
  String theDescription = '';
  String profileImageID = '';

  String hikeName = 'Karura...? More like KAZUMA!!!';
  String hikeDescription =
      'Get it? Cause this is an Ace Attorney themed hike! Come join in an adventure where we recreate Kazuma\'s iconic "Fresh Breeze Bandana"!';
  String hikeLocation = 'Katura Forest';
  String hikeDate = 'July 7, 2024';

  userCard(int num) {
    return TextButton(
        onPressed: () {
          // TODO: Add to route
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PeopleDetailView(userID: num)));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        child: Container(
          // color: ColorsUtil.describtionColorDark,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          decoration: BoxDecoration(
            color: ColorsUtil.cardColorDark,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: ColorsUtil.secondaryColorDark),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  if (displayUrl.isEmpty)
                    const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                            radius: 37,
                            backgroundColor: ColorsUtil.accentColorDark,
                            child: CircleAvatar(
                              radius: 35,
                              child: CircularProgressIndicator(),
                            )))
                  else
                    CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                            radius: 37,
                            backgroundColor: ColorsUtil.accentColorDark,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(displayUrl),
                            ))),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text(fullName[num],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark)),
                        ),
                        Text('@${username[num]}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.accentColorDark)),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ]),
        ));
  }

  @override
  void initState() {
    profileImageID = "defaultProfilePic";
    displayUrl = '';
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    int uID = widget.userID;

    theGroupName = groupName[uID];
    theDescription = description[uID];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.backgroundColorDark,
        title: const Text(
          'Hike Details',
          style: TextStyle(color: ColorsUtil.textColorDark),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.all(7),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: ColorsUtil.accentColorDark),
              color: ColorsUtil.cardColorDark,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        hikeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                            color: ColorsUtil.backgroundColorDark, width: 2),
                        color: ColorsUtil.secondaryColorDark,
                      ),
                      height: 45,
                      width: 100,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorsUtil.textColorDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 15,
                  color: ColorsUtil.accentColorDark,
                ),
                Text(
                  hikeDescription,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.textColorDark,
                  ),
                ),
                Text(
                  'Location: $hikeLocation',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.primaryColorDark,
                  ),
                ),
                Text(
                  'Date: $hikeDate',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorsUtil.primaryColorDark,
                  ),
                )
              ],
            ),
          ),

          // *********************************************************** //

          DraggableScrollableSheet(
            initialChildSize: .5,
            minChildSize: .5,
            maxChildSize: .7,
            builder: (context, scrollController) {
              return Container(
                // height: 0.25,
                width: width,
                decoration: BoxDecoration(
                  color: ColorsUtil.describtionColorDark,
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
                      // width: width,
                      margin: const EdgeInsets.all(25),
                      child: const Text(
                        'Participating Members',
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
                    for (int i = 0; i < loadNum; i++) userCard(i),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

              // Container(
              //       height: MediaQuery.of(context).size.height * .25,
              //       width: MediaQuery.of(context).size.width,
              //       decoration: const BoxDecoration(
              //         color: ColorsUtil.secondaryColorDark,
              //         borderRadius:
              //             BorderRadius.vertical(top: Radius.circular(30)),
              //       ),
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         // mainAxisSize: MainAxisSize.min,
              //         children: <Widget>[
              //           const Text('Modal BottomSheet'),
              //           ElevatedButton(
              //             child: const Text('Close BottomSheet'),
              //             onPressed: () => Navigator.pop(context),
              //           ),
              //         ],
              //       ),
              //     );
            
          // Container(
          //   width: MediaQuery.sizeOf(context).width,
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         Image(
          //           image: NetworkImage(displayUrl),
          //         ),
          //       ],
          //     ),
          //   ),

          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     showModalBottomSheet<void>(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return
          //          Container(
          //           height: MediaQuery.of(context).size.height * .25,
          //           width: MediaQuery.of(context).size.width,
          //           // padding: EdgeInsets.all(35),
          //           decoration: const BoxDecoration(
          //             color: ColorsUtil.secondaryColorDark,
          //             borderRadius:
          //                 BorderRadius.vertical(top: Radius.circular(30)),
          //           ),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             // mainAxisSize: MainAxisSize.min,
          //             children: <Widget>[
          //               const Text('Modal BottomSheet'),
          //               ElevatedButton(
          //                 child: const Text('Close BottomSheet'),
          //                 onPressed: () => Navigator.pop(context),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   child: const Text('showBelow'),
          // ),
        
