import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/people_detail_view.dart';
// ******************* DUMMY DATABASE ******************* //

// import 'package:tembeakenya/dummy_db.dart';

// ****************************************************** //

class GroupJoinView extends StatefulWidget {
  final dynamic user;
  final dynamic group;
  final Map<String, User> requests;
  const GroupJoinView(
      {super.key,
      required this.user,
      required this.group,
      required this.requests});

  @override
  State<GroupJoinView> createState() => _GroupJoinViewState();
}

// TODO: Request table that has id, name, username, and image_id

class _GroupJoinViewState extends State<GroupJoinView> {
  // ****************************************************** //
  late NavigationService navigationService;

  User? selectedUser;
  // List<User> users = [];

  String profileImageID = '';

  late int loadNum;
  late List<String> displayUrl;

  // ****************************************************** //

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
              currentUser: widget.user,
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
                Row(
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
                            backgroundImage: NetworkImage(displayUrl[num]),
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
                              widget.requests.entries
                                  .elementAt(num)
                                  .value
                                  .fullName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark),
                            ),
                          ),
                          Text(
                            '@${widget.requests.entries.elementAt(num).value.username}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.accentColorDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          // Accept request
                          CommunityController().approveJoinRequest(
                              widget.group['id'],
                              widget.requests.entries.elementAt(num).value.id!,
                              context);
                        },
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: ColorsUtil.accentColorDark,
                          size: 35,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        )),
                    IconButton(
                      onPressed: () {
                        // Decline request
                        CommunityController().rejectJoinRequest(
                            widget.group['id'],
                            widget.requests.entries.elementAt(num).value.id!,
                            context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: ColorsUtil.secondaryColorDark,
                        size: 35,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                    )
                  ],
                )
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

  @override
  void initState() {
    navigationService = NavigationService(router);

    loadNum = widget.requests.length;
    // loadNum = 1;
    displayUrl = List<String>.filled(loadNum, '');

    for (int i = 0; i < loadNum; i++) {
      // profileImageID = users[i].image_id!;
      // profileImageID = widget.requests
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Requests Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              height: 2,
              color: ColorsUtil.secondaryColorDark,
              indent: 12,
              endIndent: 12,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                children: [
                  if (loadNum == 0)
                    const Center(
                      child: Text(
                        'No Requests',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ),
                    )
                  else
                    for (int i = 0; i < loadNum; i++) userCard(i),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
