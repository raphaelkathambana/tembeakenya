import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';

import 'package:tembeakenya/views/group_create_hike_view.dart';
import 'package:tembeakenya/views/group_edit_view.dart';
import 'package:tembeakenya/views/group_event_view.dart';
import 'package:tembeakenya/views/group_join_request_view.dart';
import 'package:tembeakenya/views/group_members_view.dart';

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

//      | UserID | GoupID | RoleID |
//      | ------ | ------ | ------ |
//      | 1      | 1      | 1      |
//      | 1      | 2      | 2      |
//      | 2      | 2      | 1      |

// ****************************************************** //
class GroupDetailView extends StatefulWidget {
  final int userID;
  const GroupDetailView({super.key, required this.userID});

  @override
  State<GroupDetailView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<GroupDetailView> {
  late String displayUrl;
  late NavigationService navigationService;
  String profileImageID = "defaultProfilePic";

  late String theGroupName;
  late bool theMember;
  late String theDescription;

  late int uID;

  // TODO: Temporary
  // ***** ROLE *****  //
  late int roleID;
  late bool roleSwitch;
  // ***************** //

  eventCard(){
    return TextButton(
        onPressed: () {
          // TODO: Add to route
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupEventView(userID: uID)));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Color.fromARGB(0, 0, 0, 0))),
        child: Container(
                width: MediaQuery.sizeOf(context).width,
                // height: 100,
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorsUtil.accentColorDark),
                  color: const Color.fromARGB(29, 99, 126, 32),
                ),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title of the Hike',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ),
                      Divider(
                        height: 6,
                        color: ColorsUtil.accentColorDark,
                      ),
                      Text(
                        'Come Join us on the hike! If you want to attend the hike, make sure you fill out the form and pay.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: ColorsUtil.textColorDark,
                        ),
                      ),
                      Text(
                        'Location: Karura Forest',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ),
                      Text('Date: July 7, 2024',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: ColorsUtil.primaryColorDark,
                          ))
                    ]),
              ),
    );
  }

  @override
  void initState() {
    // TODO: Temporary
    // ***** ROLE *****  //
    roleID = 2;
    roleSwitch = true;
    // ***************** //

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    navigationService = NavigationService(router);
    displayUrl = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ****************************************************** //
    uID = widget.userID;
    theGroupName = groupName[uID];
    theMember = member[uID];
    theDescription = description[uID];
    // ****************************************************** //

    // user = widget.currentUser;
    debugPrint('Ok, Image URL: $displayUrl');

    // TODO: TEMPORARY ROLE SWITCH BUTTON
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

    sideBar(int theRole) {
      if (theRole == 1) {
        return Drawer(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Members'),
              // TODO: Add to route
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GroupMemberView())),
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Leave Group'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Leave Group'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ));
                }),
          ]),
        );
      } else if (theRole == 2) {
        return Drawer(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Members'),
              // TODO: Add to route
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GroupMemberView())),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Edit Group'),
              // TODO: Add to route
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupEditView(userID: uID))),
            ),
            ListTile(
              leading: const Icon(Icons.read_more),
              title: const Text('Membership Request'),
              // TODO: Add to route
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GroupJoinView())),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Create a Hike Event'),
              // TODO: Add to route
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GroupCreateHikeView())),
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Delete Group'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Delete'),
                            content: const Text(
                                'Would you like to send a request to delete group to admins?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Send Request'),
                              ),
                            ],
                          ));
                }),
          ]),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(57, 22, 26, 15),
          title: const Text(
            'Hike Group',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        endDrawer: sideBar(roleID),
        body: SingleChildScrollView(
            child: Column(children: [
          // Group Name
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
                        width: MediaQuery.sizeOf(context).width * .6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Text(theGroupName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsUtil.textColorDark)),
                            ),
                            if (theMember)
                              const Text('Member',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: ColorsUtil.accentColorDark)),
                            if (!theMember)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    request[uID] = !request[uID];
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 30),
                                    foregroundColor: ColorsUtil.textColorDark,
                                    backgroundColor: request[uID]
                                        ? ColorsUtil.accentColorDark
                                        : ColorsUtil.secondaryColorDark),
                                child: request[uID]
                                    ? const Text('Pending...')
                                    : const Text('Request to Join'),
                              )
                          ],
                        ),
                      ),
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
            ]),
          ),

          // Description
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                border: Border.all(color: ColorsUtil.secondaryColorDark),
                color: const Color.fromARGB(255, 49, 59, 21),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: Text('Description',
              //       style: TextStyle(
              //           fontSize: 22,
              //           fontWeight: FontWeight.bold,
              //           color: ColorsUtil.primaryColorDark)),
              // ),
              // const Divider(
              //   height: 2,
              //   color: ColorsUtil.secondaryColorDark,
              // ),
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                    color: const Color.fromARGB(29, 99, 126, 32),
                  ),
                  child: Text(theDescription,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ColorsUtil.primaryColorDark))),
            ]),
          ),

          // Events

          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
            decoration: BoxDecoration(
                border: Border.all(color: ColorsUtil.secondaryColorDark),
                color: Color.fromARGB(150, 49, 59, 21),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text('Upcoming Events',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorsUtil.primaryColorDark)),
              ),
              const Divider(
                height: 6,
                color: ColorsUtil.accentColorDark,
              ),

              eventCard(),
              
            ]),
          ),
          // TEMPORARY ROLE SWITCH BUTTON
          roleButton(),
        ])));
  }
}
