// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/group_view.dart';
import 'package:tembeakenya/views/people_view.dart';

class CommunityView extends StatefulWidget {
  final dynamic user;
  // final dynamic users;
  const CommunityView({super.key, required this.user});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  List<User> users = [];
  List<dynamic> groups = [];
  // int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    CommunityController().getCommunityGroups().then((value) {
      setState(() {
        groups = value;
      });
    });
    CommunityController().getCommunityData().then((list) {
      setState(() {
        users = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      users.isNotEmpty
          ? PeopleView(
              currentUser: widget.user,
              users: users,
            )
          : Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: const CircularProgressIndicator(),
          ),
      groups.isNotEmpty
          ? GroupView(
              user: widget.user,
              groups: groups,
            )
          : Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: const CircularProgressIndicator(),
          )
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorsUtil.backgroundColorDark,
            title: const Text(
              'Community Feed',
              style: TextStyle(color: ColorsUtil.textColorDark),
            ),
            bottom: const TabBar(
              labelPadding: EdgeInsets.only(left: 20, right: 20),
              tabs: [
                Tab(text: 'People'),
                Tab(text: 'Group'),
              ],
            ),
          ),
          body: TabBarView(
            children: tabs,
          ),
        ));
  }
}
