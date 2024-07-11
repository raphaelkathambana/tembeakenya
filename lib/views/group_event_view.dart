// group_event_view

import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_following.dart';
import 'package:tembeakenya/views/group_event_signup.dart';
import 'package:tembeakenya/views/people_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

// ******************* DUMMY DATABASE ******************* //
import 'package:tembeakenya/dummy_db.dart';

class GroupEventView extends StatefulWidget {
  final user;
  const GroupEventView({super.key, required this.user});

  @override
  State<GroupEventView> createState() => _GroupEventViewState();
}

class _GroupEventViewState extends State<GroupEventView> {
  late NavigationService navigationService;

  List<User> users = [];

  User? selectedUser;

  String theGroupName = '';
  String theDescription = '';

  String profileImageID = '';

  int loadNum = 0;
  late bool initStateAgain;
  late List<String> displayUrl;
  late List<bool?> isAttendee;
  late List<bool> attendingLoaded;
  bool loaded = false;

  String hikeName = 'Karura...? More like KAZUMA!!!';
  String hikeDescription =
      'Get it? Cause this is an Ace Attorney themed hike! Come join in an adventure where we recreate Kazuma\'s iconic "Fresh Breeze Bandana"!';
  String hikeLocation = 'Karura Forest';
  String hikeDate = 'July 7, 2024';

  // The participator's page will have the same logic as the friends
  // But instead of filtering "friends" from all group, you filter
  // "attendees" from group hikers

  userAttendee(int num) {
    if (isAttendee[num] == true) {
      return userCard(num);
    } else {
      return const SizedBox();
    }
  }

  userCard(int num) {
    if (isAttendee[num] == true) {
      return TextButton(
          onPressed: () async {
            await CommunityController().getAUsersDetails(num + 1).then(
              (user) {
                setState(() {
                  selectedUser = user;
                });
              },
            );

            if (!mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PeopleDetailView(
                  selectedUser: selectedUser!,
                  currentUser: widget.user,
                ),
              ),
            );
          },
          style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent)),
          child: Container(
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
                  Row(
                    children: [
                      if (displayUrl[num].isEmpty)
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 37,
                            backgroundColor: ColorsUtil.accentColorDark,
                            child: CircleAvatar(
                              radius: 35,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      else
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 37,
                            backgroundColor: ColorsUtil.accentColorDark,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(displayUrl[num]),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Text(
                                users[num].fullName,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.textColorDark),
                              ),
                            ),
                            Text(
                              '@${users[num].username}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.accentColorDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    navigationService = NavigationService(router);
    initStateAgain = false;

    // TODO: Create a function that gets the list of all group members
    CommunityController().getCommunityData().then((list) {
      setState(() {
        users = list;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (users.isNotEmpty) {
      if (!initStateAgain) {
        loadNum = users.length;
        debugPrint('NUMBER LOADED: $loadNum');
        displayUrl = List<String>.filled(loadNum, '');
        isAttendee = List<bool?>.filled(loadNum, false);
        attendingLoaded = List<bool>.filled(loadNum, false);

        for (int i = 0; i < loadNum; i++) {
          profileImageID = users[i].image_id!;
          getImageUrl(profileImageID).then((String result) {
            setState(() {
              displayUrl[i] = result;
            });
          });
        }
        initStateAgain = true;
      }
    }

    for (int i = 0; i < loadNum; i++) {
      if (attendingLoaded[i] == false) {
        // TODO: Create a function that filters out attendees from all group members
        getFriend(i + 1).then((value) => {
              if (isAttendee[i] = value)
                {loaded = attendingLoaded.every((element) => element = true)}
            });
        attendingLoaded[i] = true;
      }
    }

    double width = MediaQuery.sizeOf(context).width;

    // int uID = widget.user.id;
    int gID = 1;

    theGroupName = groupName[gID];
    theDescription = description[gID];

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
                      width: width * .5,
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
                        onPressed: () {
                          Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupEventSignUp(user: widget.user)));
                        },
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
                    for (int i = 0; i < loadNum; i++) userAttendee(i),
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
