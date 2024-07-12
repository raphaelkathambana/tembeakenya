import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_following.dart';

// ******************* DUMMY DATABASE ******************* //

// import 'package:tembeakenya/dummy_db.dart';
import 'package:tembeakenya/views/people_detail_view.dart';

// ****************************************************** //

class ProfileFollowingView extends StatefulWidget {
  final dynamic currentUser;
  final users;
  const ProfileFollowingView(
      {super.key, required this.currentUser, required this.users});

  @override
  State<ProfileFollowingView> createState() => _ProfileFollowingViewState();
}

class _ProfileFollowingViewState extends State<ProfileFollowingView> {
  // ****************************************************** //

  late NavigationService navigationService;

  User? users;

  User? selectedUser;

  String profileImageID = '';

  final TextEditingController _search = TextEditingController();
  String search = '';

  late int loadNum;
  late List<String> displayUrl;
  late List<bool?> isFriend;
  late List<bool> followsLoaded;
  bool loaded = false;

  // ****************************************************** //
  searchCard(String search, int num) {
    debugPrint('IS IT TRUE????: ${isFriend[num]}');
    if (search != '') {
      if (widget.users[num].fullName
          .toLowerCase()
          .contains(search.toLowerCase())) {
        return userCard(num);
      }
      return const SizedBox();
    } else {
      return userCard(num);
    }
  }

  userCard(int num) {
    if (isFriend[num] == true) {
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
                currentUser: widget.currentUser,
              ),
            ),
          );
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        child: Card(
          color: ColorsUtil.cardColorDark,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          child: Column(
            children: [
              const Divider(
                height: 2,
                color: ColorsUtil.secondaryColorDark,
                indent: 12,
                endIndent: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  !loaded
                      ? Row(
                          children: [
                            const CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              child: CircleAvatar(
                                radius: 37,
                                backgroundColor: ColorsUtil.cardColorDark,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width - 230,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    height: 20,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorsUtil.cardColorDark,
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorsUtil.cardColorDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 3.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorsUtil.cardColorDark,
                              ),
                              height: 35,
                              width: 95,
                            )
                          ],
                        )
                      : Row(
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
                                    backgroundImage:
                                        NetworkImage(displayUrl[num]),
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
                                      widget.users[num].fullName,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUtil.textColorDark),
                                    ),
                                  ),
                                  Text(
                                    '@${widget.users[num].username}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.accentColorDark),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 3.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorsUtil.accentColorDark),
                              height: 35,
                              width: 95,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isFriend[num] = !isFriend[num]!;
                                    CommunityController().unFollowUser(num + 1, context);
                                  });
                                },
                                child: const Text(
                                  'Following',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColorsUtil.textColorDark),
                                ),
                              ),
                            )
                          ],
                        ),
                ],
              ),
              const Divider(
                height: 2,
                color: ColorsUtil.secondaryColorDark,
                indent: 12,
                endIndent: 12,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  // ****************************************************** //
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    String profileImageID = '';
    followsLoaded = List<bool>.filled(loadNum, false);

    for (int i = 0; i < loadNum; i++) {
      if (followsLoaded[i] == false) {
        getFriend(i + 1).then((value) => {
              setState(() {
                if (isFriend[i] = value) {
                  loaded =
                      !isFriend.any((element) => element = element == null);
                }
              })
            });
        followsLoaded[i] = true;
      }
    }

    for (int i = 0; i < loadNum; i++) {
      profileImageID = widget.users[i].image_id!;
      getImageUrl(profileImageID).then((String result) {
        setState(() {
          displayUrl[i] = result;
        });
      });
    }
  }

  @override
  void initState() {
    navigationService = NavigationService(router);

    loadNum = widget.users.length;
    displayUrl = List<String>.filled(loadNum, '');
    isFriend = List<bool?>.filled(loadNum, null);
    followsLoaded = List<bool>.filled(loadNum, false);

    // users = List<User?>.filled(loadNum, null);

    for (int i = 0; i < loadNum; i++) {
      profileImageID = widget.users[i].image_id!;
      getImageUrl(profileImageID).then((String result) {
        setState(() {
          displayUrl[i] = result;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadNum = widget.users.length;

    for (int i = 0; i < loadNum; i++) {
      if (followsLoaded[i] == false) {
        getFriend(i + 1).then((value) => {
              setState(() {                
                if (isFriend[i] = value){
                  loaded = followsLoaded.every((element) => element = true);
                }
              })
            });
        followsLoaded[i] = true;
      }
      // loaded = !isFriend.any((element) => element = element==null);
    }
    debugPrint('IS IT LOADED????: $loadNum');

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Following',
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
            width: MediaQuery.sizeOf(context).width * .90,
            margin: const EdgeInsets.only(top: 20, bottom: 25),
            height: 50,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: ColorsUtil.cardColorDark,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: [
                // Search
                Expanded(
                  child: TextField(
                    controller: _search,
                    enableSuggestions: true,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = _search.text;
                      });
                    },
                  ),
                ),
              ],
            )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [for (int i = 0; i < loadNum; i++) searchCard(search, i)],
          ),
        ),
      ])),
    );
  }
}
