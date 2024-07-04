import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/people_detail_view.dart';

// ******************* DUMMY DATABASE ******************* //

import 'package:tembeakenya/dummy_db.dart';

// ****************************************************** //
class PeopleView extends StatefulWidget {
  final dynamic currentUser;
  const PeopleView({super.key, required user, this.currentUser});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  // ****************************************************** //

  late String displayUrl;
  late String? dropdownValue;
  List<String> listUser = <String>['All', 'Follows'];
  late NavigationService navigationService;
  User? user;

  String profileImageID = "defaultProfilePic";
  late int loadNum;

  final TextEditingController _search = TextEditingController();
  String search = '';

  // ****************************************************** //
  searchCard(String search, int num, bool isFriend) {
    if (search != '') {
      if (fullName[num].toLowerCase().contains(search.toLowerCase())) {
        return userFriend(num, isFriend);
      }
      return const SizedBox();
    } else {
      return userFriend(num, isFriend);
    }
  }

  userFriend(int num, bool isFriend) {
    if (isFriend == true) {
      if (friend[num] == true) {
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
        onPressed: () {
          // TODO: Add to route
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PeopleDetailView(userID: num)));
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
                Container(
                  margin: const EdgeInsets.only(right: 3.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: friend[num]
                        ? ColorsUtil.accentColorDark
                        : ColorsUtil.secondaryColorDark,
                  ),
                  height: 35,
                  width: 95,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        friend[num] = !friend[num];
                      });
                    },
                    child: friend[num]
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
        ));
  }

  // ****************************************************** //

  @override
  void initState() {
    dropdownValue = listUser.first;
    loadNum = fullName.length;
    displayUrl = '';
    navigationService = NavigationService(router);

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
                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
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
                    items:
                        listUser.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              ],
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              color: Color.fromARGB(0, 0, 0, 0),
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
            )),
      ])),
    );
  }
}
