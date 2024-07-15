import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_following.dart';
import 'package:tembeakenya/views/people_followers_view.dart';
import 'package:tembeakenya/views/people_following_view.dart';

class PeopleDetailView extends StatefulWidget {
  final dynamic currentUser;
  final dynamic selectedUser;
  const PeopleDetailView(
      {super.key, required this.selectedUser, required this.currentUser});

  @override
  State<PeopleDetailView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<PeopleDetailView> {
  List<User> users = [];
  User? user;
  String displayUrl = '';
  late NavigationService navigationService;
  String profileImageID = '';

  // ****************************************************** //

  late String theFullName;
  late String theUsername;
  late bool theFriend;
  late int theStepsTaken;
  late int theDistanceWalked;
  late int theHikes;
  bool isFriend = false;
  // ****************************************************** //

  @override
  void initState() {
    user = widget.selectedUser;
    profileImageID = user!.image_id!;

    // profileImageID = widget.selectedUser.image_id!;

    debugPrint("user: ${widget.selectedUser.fullName.toString()}");
    debugPrint("user: ${widget.selectedUser.no_of_hikes.toString()}");
    debugPrint("user: $profileImageID");
    // debugPrint(getReviews().toString());

    CommunityController().getCommunityData().then((list) async {
      setState(() {
        users = list;
      });
    });

    CommunityController().getAUsersDetails(widget.selectedUser.id!).then(
      (selectedUser) {
        setState(() {
          user = selectedUser;
        });
      },
    );

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    getFollowingFriend(widget.selectedUser.id!).then((value) => {
          setState(() {
            isFriend = value;
          })
        });

    navigationService = NavigationService(router);
    super.initState();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    profileImageID = user!.image_id!;
    displayUrl = '';

    getFollowingFriend(widget.selectedUser.id!).then(
      (value) => {
        setState(() {
          isFriend = value;
        })
      },
    );

    CommunityController().getCommunityData().then((list) async {
      setState(() {
        users = list;
      });
    });

    CommunityController().getAUsersDetails(widget.selectedUser.id!).then(
      (selectedUser) {
        setState(() {
          user = selectedUser;
        });
      },
    );

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    debugPrint('Ok, Image URL: $displayUrl');
  }

  @override
  Widget build(BuildContext context) {
    theFullName = user!.fullName;
    theUsername = user!.username!;
    theStepsTaken = user!.no_of_steps_taken!;
    theDistanceWalked = user!.total_distance_walked!;
    theHikes = user!.no_of_hikes!;

    debugPrint('Ok, Image URL: $displayUrl');

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: const EdgeInsets.only(right: 3.5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: ColorsUtil.cardColorDark,
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
                                  backgroundColor: Colors.transparent,
                                  child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor:
                                          ColorsUtil.accentColorDark,
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
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                backgroundColor:
                                                    ColorsUtil.accentColorDark,
                                                child: CircleAvatar(
                                                  radius:
                                                      MediaQuery.sizeOf(context)
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
                                    width:
                                        MediaQuery.sizeOf(context).width * .35,
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
                        isFriend
                            ? Container(
                                margin: const EdgeInsets.only(right: 3.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorsUtil.accentColorDark),
                                height: 35,
                                width: 95,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isFriend = !isFriend;
                                      CommunityController().unFollowUser(
                                          widget.selectedUser.id!, context);
                                    });
                                  },
                                  child: const Text(
                                    'Following',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsUtil.textColorDark),
                                  ),
                                ))
                            : Container(
                                margin: const EdgeInsets.only(right: 3.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorsUtil.secondaryColorDark),
                                height: 35,
                                width: 95,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isFriend = !isFriend;
                                      CommunityController().followUser(
                                          widget.selectedUser.id!, context);
                                    });
                                  },
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsUtil.textColorDark),
                                  ),
                                ))
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

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                // TODO: Page not fully functional
                                  builder: (context) => PeopleFollowersView(
                                        currentUser: widget.currentUser,
                                        selectedUser: widget.selectedUser,
                                        users: users,
                                      )));
                        },
                        child: Column(
                          children: [
                            if (user!.followers_count == 1)
                              Text(
                                '${user!.followers_count} Follower',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.accentColorLight,
                                ),
                              )
                            else 
                              Text(
                                '${user!.followers_count} Followers',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.accentColorLight,
                                ),
                              )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                // TODO: Page not fully functional
                                  builder: (context) =>
                                      PeopleFollowingView(
                                        currentUser: widget.currentUser,
                                        selectedUser: widget.selectedUser,
                                        users: users,
                                      )));
                        },
                        child: Column(
                          children: [
                            Text(
                              '${user!.following_count} Following',
                              //  textAlign
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.accentColorLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Statistic has dummy writing
                Container(
                  height: 367,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Statistics',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        const Divider(
                          height: 15,
                          color: ColorsUtil.secondaryColorDark,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [                                
                                const Text('Number of Hikes',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.primaryColorDark)),
                                Row(children: [
                                  Text(user!.no_of_hikes.toString(),
                                      style: const TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUtil.textColorDark)),
                                  const Text(' Hikes',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: ColorsUtil.textColorDark)),
                                ]),
                                const Text('Number of Steps Taken',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.primaryColorDark)),
                                Row(children: [
                                  Text(user!.no_of_steps_taken.toString(),
                                      style: const TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUtil.textColorDark)),
                                  const Text(' Steps',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: ColorsUtil.textColorDark)),
                                ]),
                                const Text('Total Distance Walked',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.primaryColorDark)),
                                Row(children: [
                                  Text(user!.total_distance_walked.toString(),
                                      style: const TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUtil.textColorDark)),
                                  const Text(' m',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: ColorsUtil.textColorDark)),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ]),
                ),

                // Milestone has dummy writing
                Container(
                  height: 350,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 0),
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
                                  child: const Text(
                                      'There are no Milestones yet',
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
              ])),
        ));
  }
}
