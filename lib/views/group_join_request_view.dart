import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';

// ******************* DUMMY DATABASE ******************* //

import 'package:tembeakenya/dummy_db.dart';
import 'package:tembeakenya/views/people_detail_view.dart';

// ****************************************************** //

class GroupJoinView extends StatefulWidget {
  // final int userID;
  const GroupJoinView({super.key});

  @override
  State<GroupJoinView> createState() => _GroupJoinViewState();
}

class _GroupJoinViewState extends State<GroupJoinView> {
  // ****************************************************** //

  late String displayUrl;
  late String? dropdownValue;
  List<String> listUser = <String>['All', 'Friend'];
  late NavigationService navigationService;
  // User? user;

  String profileImageID = "defaultProfilePic";
  late int loadNum;

  // ****************************************************** //

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
        child: Card(
          color: ColorsUtil.cardColorDark,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child: Column(children: [
            const Divider(
              height: 2,
              color: ColorsUtil.secondaryColorDark,
              indent: 12,
              endIndent: 12,
            ),
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark)),
                        ),
                        
                      ],
                    ),
                  ),
                ]),
                  Row(children: [
                    IconButton(
                      onPressed: () {},
                      icon: 
                      const Icon(
                        Icons.check_circle_outline,
                        color: ColorsUtil.accentColorDark,
                        size: 35,
                        semanticLabel: 'Text to announce in accessibility modes',
                      )
                    ),
                    IconButton(
                      onPressed: () {}, 
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: ColorsUtil.secondaryColorDark,
                        size: 35,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    )
                  ],
                )
              ],
            ),
            const Divider(
              height: 2,
              color: ColorsUtil.secondaryColorDark,
              indent: 12,
              endIndent: 12,
            ),
          ]),
        ));
  }

  @override
  void initState() { 
    displayUrl = '';
    navigationService = NavigationService(router);
    loadNum = fullName.length;

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorsUtil.backgroundColorDark,
            title: const Text(
              'Requests Page',
              style: TextStyle(color: ColorsUtil.textColorDark),
            )),
        body: SingleChildScrollView(
        child: Column(children: [
      const Divider(
        height: 2,
        color: ColorsUtil.secondaryColorDark,
        indent: 12,
        endIndent: 12,
      ),
      
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              for (int i = 0; i < loadNum; i++) 
                  userCard(i)
            ],
          )),
    ])),
        // body: const Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //         Text('GroupJoinView: Page Incomplete',
        //             style: TextStyle(
        //                 fontSize: 15,
        //                 fontWeight: FontWeight.normal,
        //                 color: ColorsUtil.primaryColorDark))
        //       ]),
        //     ]),
            
            );
  }
}
