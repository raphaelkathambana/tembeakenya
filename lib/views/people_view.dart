import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_following.dart';
import 'package:tembeakenya/views/people_detail_view.dart';
// import 'package:tembeakenya/dummy_db.dart';

class PeopleView extends StatefulWidget {
  final dynamic currentUser;
  final users;
  const PeopleView({super.key, this.currentUser, required this.users});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  late NavigationService navigationService;

  late String? dropdownValue;
  List<String> listUser = <String>['All', 'Follows'];

  User? selectedUser;

  String profileImageID = '';

  final TextEditingController _search = TextEditingController();
  String search = '';

  late int loadNum;
  late List<String> displayUrl;
  late List<bool?> isFriend;
  // bool? followLoaded = false;
  late List<bool> followsLoaded;
  bool loaded = false;

  searchCard(String search, int num, bool friend) {
    if (search != '') {
      if (widget.users[num].fullName
          .toLowerCase()
          .contains(search.toLowerCase())) {
        return userFriend(num, friend);
      }
      return const SizedBox();
    } else {
      return userFriend(num, friend);
    }
  }

  userFriend(int num, bool friend) {
    if (widget.users[num].id == widget.currentUser.id){
      return const SizedBox();
    }
    if (friend == true) {
      if (isFriend[num] == true) {
        return userCard(num);
      } else {
        return const SizedBox();
      }
    } else {
      return userCard(num);
    }
  }

  userCard(int num) {
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
                          // TODO
                          isFriend[num]!
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
                                        isFriend[num] = !isFriend[num]!;
                                        CommunityController()
                                            .unFollowUser(num + 1, context);
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
                                        isFriend[num] = !isFriend[num]!;
                                        CommunityController()
                                            .followUser(num + 1, context);
                                      });
                                    },
                                    child: const Text(
                                      'Follow',
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
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    String profileImageID = '';
    followsLoaded = List<bool>.filled(loadNum, false);

    setState(() {
      widget.users;
    });

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
    dropdownValue = listUser.first;
    loadNum = widget.users.length;
    displayUrl = List<String>.filled(loadNum, '');
    isFriend = List<bool?>.filled(loadNum, false);
    followsLoaded = List<bool>.filled(loadNum, false);

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
    for (int i = 0; i < loadNum; i++) {
      if (followsLoaded[i] == false) {
        getFriend(i + 1).then(
          (value) => {
            // isFriend[i] = value
            if (isFriend[i] = value) {
              loaded = followsLoaded.every((element) => element = true),
            }
          },
        );
        followsLoaded[i] = true;
        Future.delayed(const Duration(seconds: 3), () {
          loaded = followsLoaded.every((element) => element = true);
        });
      }
    }

    debugPrint('LOADED: $loaded');

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
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
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin:
                          const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        style: const TextStyle(fontSize: 14),
                        underline: Container(height: 2),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: listUser
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < loadNum; i++)
                      if (dropdownValue ==
                          listUser.last) // If dropdown indicates "Friends"
                        searchCard(search, i, true)
                      else if (dropdownValue ==
                          listUser.first) // If dropdown indicates "All"
                        searchCard(search, i, false)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
