import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/profile_followers_view.dart';
import 'package:tembeakenya/views/profile_following_view.dart';

class ProfileView extends StatefulWidget {
  final User currentUser;
  const ProfileView({super.key, required this.currentUser});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<User> users = [];

  User? user;
  late String displayUrl;
  late NavigationService navigationService;
  bool _isLoading = false;
  String profileImageID = '';
  late int followersCount;
  late int followingCount;

  @override
  void initState() {
    user = widget.currentUser;
    followingCount = user!.following_count!;
    navigationService = NavigationService(router);

    profileImageID = user!.image_id!;
    displayUrl = '';

    debugPrint('ID NUMBER: ${user!.id}');

    CommunityController().getCommunityData().then((list) async {
      setState(() {
        users = list;
      });
    });

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    debugPrint('Ok, Image URL: $displayUrl');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _handleRefresh();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        endDrawer: Drawer(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () =>
                  navigationService.navigatePushToEditProfile(context, user),
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Change Password'),
              onTap: () =>
                  navigationService.navigatePushToChangePassword(context, user),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: _isLoading ? null : _handleLogout,
            ),
          ]),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                Card(
                  color: ColorsUtil.cardColorDark,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(children: [
                    const Divider(
                      height: 2,
                      color: ColorsUtil.secondaryColorDark,
                      indent: 12,
                      endIndent: 12,
                    ),
                    Row(
                      children: [
                        // const SizedBox(width: 10),
                        if (displayUrl.isEmpty)
                          const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
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
                                            radius: MediaQuery.sizeOf(context)
                                                .width,
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
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * .6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user!.fullName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold,
                                      color: ColorsUtil.textColorDark)),
                              Text('@${user!.username.toString()}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: ColorsUtil.primaryColorDark)),
                            ],
                          ),
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

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  // padding: const EdgeInsets.only(
                  //     left: 20, right: 20,),
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
                                  builder: (context) =>
                                      // users.isNotEmpty ?
                                      ProfileFollowersView(
                                        currentUser: widget.currentUser,
                                        users: users,
                                      )));
                        },
                        child: Column(
                          children: [
                            Text(
                              '${user!.followers_count} Followers',
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      // users.isNotEmpty ?
                                      ProfileFollowingView(
                                        currentUser: widget.currentUser,
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

                // Email
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: const EdgeInsets.only(
                      left: 10, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    user!.email.toString(),
                    style: const TextStyle(
                        fontSize: 15, color: ColorsUtil.textColorDark),
                  ),
                ),

                // Statistic has dummy writing
                Container(
                  height: 350,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
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
                        const Text('Milestones',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0)),
                        const Divider(
                          height: 2,
                          color: ColorsUtil.secondaryColorDark,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0)),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * .7,
                                    child: const Text(
                                        'There are no Milestones yet',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                ColorsUtil.primaryColorDark))),
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

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    AuthController(navigationService).refreshUserDetails().then((value) {
      setState(() {
        user = value;
      });
    });
    setState(() {
      followingCount = user!.following_count!;

      profileImageID = user!.image_id!;
      displayUrl = '';
    });

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    debugPrint('Ok, Image URL: $displayUrl');
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    bool isLoggedOut = await AuthController(navigationService).logout();

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    if (isLoggedOut) {
      // Navigate to the login or welcome screen
      if (!mounted) return;
      // context.go('/login');
      navigationService.navigateToLogin(context);
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }
}
