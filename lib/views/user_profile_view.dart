import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/model/user_model.dart';
import 'package:tembeakenya/dummy_db.dart';

class UserProfileView extends StatefulWidget {
  // final dynamic currentUser;
  // const UserProfileView({super.key, required this.currentUser, required user});
  final int userID;
  const UserProfileView({super.key, required this.userID});

  @override
  State<UserProfileView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<UserProfileView> {
  late String displayUrl;
  User? user;
  late NavigationService navigationService;
  // bool _isLoading = false;
  String profileImageID = "defaultProfilePic";

  // ****************************************************** //
  late String theFullName;
  late String theUsername;
  late bool theFriend;
  // ****************************************************** //

  @override
  void initState() {
    navigationService = NavigationService(router);
    displayUrl = '';
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ****************************************************** //
    int uID = widget.userID;
    theFullName = fullName[uID];
    theUsername = username[uID];
    theFriend = friend[uID];
    // ****************************************************** //

    // user = widget.currentUser;
    debugPrint('Ok, Image URL: $displayUrl');

    // NavigationService navigationService = NavigationService(router);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(57, 22, 26, 15),
          title: const Text(
            'Profile Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(55, 99, 126, 32),
            ),
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
                  Row(
                    children: [
                      // const SizedBox(width: 10),
                      if (displayUrl.isEmpty)
                        const CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0x00000000),
                            child: CircleAvatar(
                                radius: 42,
                                backgroundColor: ColorsUtil.accentColorDark,
                                child: CircleAvatar(
                                  radius: 40,
                                  child: CircularProgressIndicator(),
                                )))
                      else
                        IconButton(
                          icon: CircleAvatar(
                              radius: 42,
                              backgroundColor: ColorsUtil.accentColorDark,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(displayUrl),
                              )),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: CircleAvatar(
                                          radius: 140,
                                          backgroundColor:
                                              ColorsUtil.accentColorDark,
                                          child: CircleAvatar(
                                            radius: 138,
                                            backgroundImage:
                                                NetworkImage(displayUrl),
                                          )),
                                    ));
                          },
                        ),
                      // const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .55,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.85,
                              child: Text(theFullName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUtil.textColorDark)),
                            ),
                            Text('@$theUsername',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: ColorsUtil.accentColorDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        friend[uID] = !friend[uID];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(95, 35),
                        foregroundColor: ColorsUtil.textColorDark,
                        backgroundColor: friend[uID]
                            ? ColorsUtil.accentColorDark
                            : ColorsUtil.secondaryColorDark),
                    child:
                        friend[uID] ? const Text('Friends') : const Text('Add'),
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
          ),

          // Statistic has dummy writing
          Container(
            height: 350,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 59, 21),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statistics',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark)),
                  Divider(
                    height: 15,
                    color: ColorsUtil.secondaryColorDark,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Number of Hikes',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.primaryColorDark)),
                          Row(children: [
                            Text('1 ',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.textColorDark)),
                            Text('hikes',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: ColorsUtil.textColorDark)),
                          ])
                        ],
                      ),
                    ],
                  ),
                ]),
          ),

          // Milestone has dummy writing
          Container(
            height: 350,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 59, 21),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Milestones',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark)),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
                  Divider(
                    height: 2,
                    color: ColorsUtil.secondaryColorDark,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('There are no Milestones yet',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.primaryColorDark)),
                          Row(children: [
                            Text(' ',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.textColorDark)),
                            Text(' ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: ColorsUtil.textColorDark)),
                          ])
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ])));
  }
}
