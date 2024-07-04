import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
// import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/dummy_db.dart';

class PeopleDetailView extends StatefulWidget {
  // final dynamic currentUser;
  // const UserProfileView({super.key, required this.currentUser, required user});
  final int userID;
  const PeopleDetailView({super.key, required this.userID});

  @override
  State<PeopleDetailView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<PeopleDetailView> {
  late String displayUrl;
  late NavigationService navigationService;
  // String profileImageID = "";
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
    super.initState();
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ****************************************************** //
    int uID = widget.userID;
    theFullName = fullName[uID];
    theUsername = username[uID];
    theFriend = friend[uID];
    // ****************************************************** //

    debugPrint('Ok, Image URL: $displayUrl');

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
            padding: const EdgeInsets.only(right: 3.5),
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
                                builder: (context) => Container(
                                      padding: const EdgeInsets.all(15),
                                      child: CircleAvatar(
                                          radius:
                                              MediaQuery.sizeOf(context).width,
                                          backgroundColor:
                                              ColorsUtil.accentColorDark,
                                          child: CircleAvatar(
                                            radius: MediaQuery.sizeOf(context)
                                                    .width *
                                                .45,
                                            backgroundImage:
                                                NetworkImage(displayUrl),
                                          )),
                                    ));
                          },
                        ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(theFullName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUtil.textColorDark)),
                            ),
                            Text('@$theUsername',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: ColorsUtil.accentColorDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                  margin: const EdgeInsets.only(right: 3.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  color: friend[uID]
                            ? ColorsUtil.accentColorDark
                            : ColorsUtil.secondaryColorDark,
                  ),
                  height: 35,
                  width: 95,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        friend[uID] = !friend[uID];
                      }); 
                    },
                    child: friend[uID]
                        ? const Text(
                            'Following',
                            style: TextStyle(
                                fontSize: 15, color: ColorsUtil.textColorDark),
                          )
                        : const Text(
                            'Follow',
                            style: TextStyle(
                                fontSize: 15, color: ColorsUtil.textColorDark),
                          ),
                  )
                ),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Text('Milestones',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtil.primaryColorDark)),
              ),
              const Divider(
                height: 2,
                color: ColorsUtil.secondaryColorDark,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .7,
                        child: const Text('There are no Milestones yet',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.primaryColorDark)),
                      ),
                      const Row(children: [
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