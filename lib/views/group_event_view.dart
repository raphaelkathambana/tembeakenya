// group_event_view

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';

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

  String theGroupName = '';
  String theDescription = '';
  String profileImageID = '';

  @override
  void initState() {
    profileImageID = "karura";
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
          SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(displayUrl),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: .08,
            minChildSize: .08,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                // height: 0.25,
                width: width,
                decoration: const BoxDecoration(
                  color: ColorsUtil.secondaryColorDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      height: 80,
                      width: width,
                      decoration: BoxDecoration(
                        color: ColorsUtil.secondaryColorDark,
                        border: Border.all(color: ColorsUtil.accentColorDark),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30)),
                      ),
                    )
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
        
