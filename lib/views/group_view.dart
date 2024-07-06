import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/group_create_view.dart';
import 'package:tembeakenya/views/group_detail_view.dart';

// ******************* DUMMY DATABASE ******************* //
  import 'package:tembeakenya/dummy_db.dart';

  // ****************************************************** //

  //      | RoleID | Role        |
  //      | ------ | ----------- |
  //      | 1      | Hike        |
  //      | 2      | Guide       |
  //      | 3      | Super Admin |

  // *********** EXAMPLE DB ************ //

  //      | UserID | RoleID |
  //      | ------ | ------ |
  //      | 1      | 1      |
  //      | 1      | 2      |
  //      | 2      | 1      |

// ****************************************************** //

class GroupView extends StatefulWidget {
  final dynamic currentUser;
  const GroupView({super.key, required user, this.currentUser});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  // ***** ROLE *****  //
  late int roleID;
  late bool roleSwitch;

  // TEMPORARY ROLE SWITCH BUTTON
  roleButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          roleSwitch = !roleSwitch;
          roleID = roleSwitch ? 2 : 1;
        });
      },
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 30),
          foregroundColor: ColorsUtil.textColorDark,
          backgroundColor: roleSwitch
              ? ColorsUtil.secondaryColorDark
              : ColorsUtil.accentColorDark),
      child: roleSwitch ? const Text('Guide') : const Text('Hiker'),
    );
  }
  // ***************** //

  late String displayUrl;
  late String? dropdownValue;
  List<String> listGroup = <String>['All Groups', 'My Groups'];
  late NavigationService navigationService;
  User? user;

  String profileImageID = "defaultProfilePic";
  late int loadNum;

  final TextEditingController _search = TextEditingController();
  String search = '';


  searchCard(String search, int num, bool isMember) {
    if (search != '') {
      if (groupName[num].toLowerCase().contains(search.toLowerCase())) {
        return groupMember(num, isMember);
      }
      return const SizedBox();
    } else {
      return groupMember(num, isMember);
    }
  }

  groupMember(int num, bool isMember) {
    if (isMember == true) {
      if (member[num] == true) {
        return groupCard(num);
      } else {
        return const SizedBox();
      }
    } else {
      return groupCard(num); // If isMember is false, continue with userCard
    }
  }

  groupCard(int num) {
    return TextButton(
        onPressed: () {
          // TODO: Add to route
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupDetailView(userID: num)));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorsUtil.secondaryColorDark),
            color: ColorsUtil.cardColorDark,
          ),
          height: 270,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
          child: Column(children: [
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
                          child: Text(groupName[num],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark)),
                        ),
                        if (member[num])
                          const Text('Member',
                              style: TextStyle(
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
              color: ColorsUtil.accentColorDark,
              indent: 12,
              endIndent: 12,
            ),
            Container(
                width: MediaQuery.sizeOf(context).width * .9,
                height: 150,
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorsUtil.backgroundColorDark),
                  color: ColorsUtil.describtionColorDark,
                ),
                child: Text(
                    description[num],
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: ColorsUtil.primaryColorDark))),
          ]),
        ));
  }

  createGroup() {
    return TextButton(
      onPressed: () {
        // TODO: Add to route
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const GroupCreateView()));
        },
      style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent)),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtil.secondaryColorDark),
          color: ColorsUtil.cardColorDark,
        ),
        height: 70,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
        child: Column(
          children: [
            Container(
              // width: MediaQuery.sizeOf(context).width * .35,
              padding: const EdgeInsets.all(15),
              child: const Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add_box_outlined),
                  Text('  Create New Group',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorsUtil.primaryColorDark)),
                  
                ],
              ),
            ),
          ],
        ),
      ));
  }
  // ****************************************************** //

  @override
  void initState() {
    // ***** ROLE *****  //
    roleID = 2;
    roleSwitch = true;
    // ***************** //

    dropdownValue = listGroup.first;
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
    debugPrint('URL: $displayUrl');

    loadNum = groupName.length;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      // TEMPORARY ROLE SWITCH BUTTON
      roleButton(),
      
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
                      listGroup.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
            ],
          )),

      if (roleID == 2) 
        createGroup(),
      
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              for (int i = 0; i < loadNum; i++)
                if (dropdownValue ==
                    listGroup.last) // If dropdown indicates "Friends"
                  searchCard(search, i, true)
                else if (dropdownValue ==
                    listGroup.first) // If dropdown indicates "All"
                  searchCard(search, i, false)
            ],
          )),
    ])));
  }
}
