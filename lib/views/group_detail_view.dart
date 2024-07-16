import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_group_members.dart';
import 'package:tembeakenya/repository/get_users.dart';

import 'package:tembeakenya/views/group_event_create_view.dart';
import 'package:tembeakenya/views/group_edit_view.dart';
import 'package:tembeakenya/views/group_event_view.dart';
import 'package:tembeakenya/views/group_join_request_view.dart';
import 'package:tembeakenya/views/group_members_view.dart';

class GroupDetailView extends StatefulWidget {
  final dynamic user;
  final dynamic group;
  final dynamic details;
  const GroupDetailView(
      {super.key,
      required this.user,
      required this.group,
      required this.details});

  @override
  State<GroupDetailView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<GroupDetailView> {
  late NavigationService navigationService;
  late String displayUrl;
  late String profileImageID;

  late String theGroupName;
  late String theDescription;

  late int roleID;
  late bool roleSwitch;
  late bool requested;

  late int loadNum;
  dynamic detailEvent;
  late List<int> theHikeID;
  late Map<String, dynamic>? groupDetails;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    CommunityController().getGroupDetails(widget.group['id']).then(
      (group) {
        setState(() {
          groupDetails = group;
        });
      },
    );

    
    setState(() {      
      loadNum = groupDetails!.length;
      
      detailEvent = groupDetails!['events'];
      var group = widget.group;
      theGroupName = group['name'];
      theDescription = group['description'];
    });

    displayUrl = '';
    for (int i = 0; i < loadNum; i++) {
      profileImageID = widget.group['image_id'];
      getImageUrl(profileImageID).then((String result) {
        setState(() {
          displayUrl = result;
        });
      });
    }

    hasRequestedToJoinGroup(widget.user, widget.group['id']).then((value) {
      setState(() {
        requested = value;
      });
    });
  }

  @override
  void initState() {
    requested = false;

    loadNum = widget.details.length;
    // if(widget.details['events'] != null){
      detailEvent = widget.details['events'];
    // }
    var group = widget.group;
    theGroupName = group['name'];
    theDescription = group['description'];

    User user = widget.user;

    if (group['guide_id'] == user.id) {
      roleID = user.role_id!;
      roleSwitch = canEdit(roleID);
    } else {
      roleID = 1;
      roleSwitch = canEdit(roleID);
    }

    displayUrl = '';
    profileImageID = widget.group['image_id'];
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    navigationService = NavigationService(router);
    groupDetails = widget.details;

    Timer.periodic(const Duration(seconds: 30), (timer) {
      CommunityController().getGroupDetails(widget.group['id']).then(
        (group) {
          setState(() {
            groupDetails = group;
          });
        },
      );
    });

    hasRequestedToJoinGroup(widget.user, widget.group['id']).then((value) {
      setState(() {
        requested = value;
      });
    });
    super.initState();
  }

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
      child: roleSwitch
          ? const Text('debug button: Group\'s Guide')
          : const Text('debug button: Hiker'),
    );
  }
  // ***************** //

  sideBar(int theRole) {
    if (theRole == 1) {
      return Drawer(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Members'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupMemberView(
                            members: widget.details['members'],
                            group: widget.group,
                            user: widget.user,
                          )));
            },
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
    } else {
      return Drawer(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Members'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupMemberView(
                            members: widget.details['members'],
                            group: widget.group,
                            user: widget.user,
                          )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Edit Group'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupEditView(
                          group: widget.group,
                          user: widget.user,
                        ))),
          ),
          ListTile(
            leading: const Icon(Icons.read_more),
            title: const Text('Membership Request'),
            onTap: () async {
              await CommunityController()
                  .getJoinRequests(widget.group['id'])
                  .then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupJoinView(
                              user: widget.user,
                              group: widget.group,
                              requests: value,
                            )));
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Create a Hike Event'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupCreateHikeView(
                          user: widget.user,
                          group: widget.group,
                        ))),
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

  noEventCard() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(10),
      child: const Text(
        'There are no upcoming events...',
        style: TextStyle(color: ColorsUtil.primaryColorDark, fontSize: 16),
      ),
    );
  }

  eventCard(int eventID) {
    dynamic selectedEvent;
    var selectedHikeID = detailEvent![eventID]['id'];

    return TextButton(
      onPressed: () async {
        // Load the hike detail
        await CommunityController()
            .getGroupHikesDetails(selectedHikeID)
            .then((value) {
          setState(() {
            selectedEvent = value;
          });
        });
        if (!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupEventView(
                      user: widget.user,
                      group: widget.group,
                      details: selectedEvent,
                    )));
      },
      style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent)),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        // height: 100,
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtil.accentColorDark),
          color: ColorsUtil.descriptionColorDark,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              groupDetails?['events']?[eventID]['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.primaryColorDark,
              ),
            ),
            const Divider(
              height: 6,
              color: ColorsUtil.accentColorDark,
            ),
            Text(
              groupDetails?['events']?[eventID]['description'],
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: ColorsUtil.primaryColorDark,
              ),
            ),
            const Text(
              'Click for more details',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: ColorsUtil.primaryColorDark,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hike Group',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        endDrawer: sideBar(roleID),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                // Group Name
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                              width: MediaQuery.sizeOf(context).width * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * .35,
                                    child: Text(theGroupName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsUtil.textColorDark)),
                                  ),
                                  if (isGroupMember(widget.user))
                                    if (widget.user.id ==
                                        widget.group['guide_id'])
                                      const Text('Guide',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtil.accentColorDark))
                                    else
                                      const Text('Member',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtil.accentColorDark)),
                                  if (!isGroupMember(widget.user))
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          // TODO: add the request functionality
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(150, 30),
                                          foregroundColor:
                                              ColorsUtil.textColorDark,
                                          backgroundColor: requested
                                              ? ColorsUtil.accentColorDark
                                              : ColorsUtil.secondaryColorDark),
                                      child: requested
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorsUtil.secondaryColorDark),
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.sizeOf(context).width,
                            // height: 100,
                            margin: const EdgeInsets.all(7),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: ColorsUtil.backgroundColorDark),
                              color: ColorsUtil.descriptionColorDark,
                            ),
                            child: Text(theDescription,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: ColorsUtil.primaryColorDark))),
                      ]),
                ),

                // Events
                if (isGroupMember(widget.user))
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 5, right: 5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorsUtil.secondaryColorDark),
                        color: const Color.fromARGB(150, 49, 59, 21),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text('Upcoming Events',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.textColorDark)),
                          ),
                          const Divider(
                            height: 6,
                            color: ColorsUtil.accentColorDark,
                          ),
                          if (loadNum == 0)
                            noEventCard()
                          else if (detailEvent.isEmpty) // if they don't have any hikeID from hike-group
                            noEventCard()
                          else
                            for (int i = 0;
                                i < detailEvent.length;
                                i++)
                              eventCard(i),
                        ]),
                  ),
                roleButton(),
              ])),
        ));
  }
}
