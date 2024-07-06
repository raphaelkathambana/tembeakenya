import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/community_controller.dart';

// ******************* DUMMY DATABASE ******************* //

import 'package:tembeakenya/dummy_db.dart';
import 'package:tembeakenya/views/people_detail_view.dart';

// ****************************************************** //

class GroupMemberView extends StatefulWidget {
  final user;
  const GroupMemberView({super.key, required this.user});

  @override
  State<GroupMemberView> createState() => _GroupMemberViewState();
}

class _GroupMemberViewState extends State<GroupMemberView> {
  // ****************************************************** //

  late String displayUrl;
  late NavigationService navigationService;

  String profileImageID = "defaultProfilePic";
  late int loadNum;

  final TextEditingController _search = TextEditingController();
  String search = '';

  // ****************************************************** //
  searchCard(String search, int num) {
    if (search != '') {
      if (fullName[num].toLowerCase().contains(search.toLowerCase())) {
        return userCard(num);
      }
      return const SizedBox();
    } else {
      return userCard(num);
    }
  }

  userCard(int num) {
    return TextButton(
        onPressed: () {
          // TODO: Add to route
          final selectedUser = CommunityController().getAUsersDetails(num);
          navigationService.navigateToPeopleDetailsView(context, widget.user);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PeopleDetailView(
                        selectedUser: selectedUser,
                        currentUser: widget.user,
                      )));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Color.fromARGB(0, 0, 0, 0))),
        child: Card(
          color: const Color.fromARGB(55, 99, 126, 32),
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
                        backgroundColor: Color(0x00000000),
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
                        backgroundColor: const Color(0x00000000),
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
            const Divider(
              height: 2,
              color: ColorsUtil.secondaryColorDark,
              indent: 12,
              endIndent: 12,
            ),
          ]),
        ));
  }

  // ****************************************************** //

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
            'Members',
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
              color: const Color.fromARGB(55, 99, 126, 32),
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
              color: Color.fromARGB(0, 0, 0, 0),
            ),
            child: Column(
              children: [
                for (int i = 0; i < loadNum; i++) searchCard(search, i)
              ],
            )),
      ])),
      // body: const Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //         Text('GroupMemberView: Page Incomplete',
      //             style: TextStyle(
      //                 fontSize: 15,
      //                 fontWeight: FontWeight.normal,
      //                 color: ColorsUtil.primaryColorDark))
      //       ]),
      //     ])
    );
  }
}
