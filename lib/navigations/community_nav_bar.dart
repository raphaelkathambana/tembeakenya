// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/views/group_view.dart';
import 'package:tembeakenya/views/people_view.dart';

class CommunityView extends StatefulWidget {
  final dynamic user;
  const CommunityView({super.key, required this.user});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  // int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      PeopleView(
        user: widget.user,
      ),
      GroupView(
        user: widget.user
      )
    ];
    return DefaultTabController (
      length: tabs.length,
      child: Scaffold (
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
    )
    );
  }
}
