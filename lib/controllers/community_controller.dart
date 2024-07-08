import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_a_user.dart';
import 'package:tembeakenya/repository/get_groups.dart';
import 'package:tembeakenya/repository/get_users.dart';

class CommunityController {
  final APICall apiCall = APICall();
  final NavigationService navigationService = NavigationService(router);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> navigatorKey2 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> navigatorKey3 = GlobalKey<NavigatorState>();

  Future<List<User>> getCommunityData() async {
    try {
      var response = await apiCall.client.get('${url}api/users');
      if (response.statusCode == 200) {
        return getUsersFromData(response.data);
      } else {
        return [];
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      return [];
    }
  }

  Future<void> followUser(int id) async {
    try {
      var response = await apiCall.client.post('${url}api/users/$id/follow');
      if (response.statusCode == 200) {
        debugPrint('Successfully Followed');
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  Future<void> unFollowUser(int id) async {
    try {
      var response = await apiCall.client.post('${url}api/users/$id/unfollow');
      if (response.statusCode == 200) {
        debugPrint('Successfully Unfollowed');
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  Future<List<dynamic>> getCommunityGroups() async {
    try {
      var response = await apiCall.client.get('${url}api/groups');
      if (response.statusCode == 200) {
        return getGroupsFromData(response.data);
      } else {
        return [];
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      return [];
    }
  }

  getAUsersDetails(int id) async {
    try {
      var response = await apiCall.client.get('${url}api/users/$id');
      if (response.statusCode == 200) {
        return getAUserDetails(response.data);
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      return null;
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // return getCommunityData();
  }

  Future<void> createGroup(String name, String description, int guideId,
      BuildContext context) async {
    String token = await getCsrfToken();
    try {
      var response = await apiCall.client.post('${url}api/groups',
          data: jsonEncode({
            'name': name,
            'description': description,
            'guide_id': guideId,
          }),
          options: Options(headers: {
            'X-XSRF-TOKEN': token,
            'Accept': 'application/json',
          }));
      if (response.statusCode == 201) {
        // snackbar for created successfully
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group created successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        // delay 3 seconds
        await Future.delayed(const Duration(seconds: 1));
        // return to group view
        if (!context.mounted) return;
        context.pop();
        // navigationService.navigateTo(
        //   '',
        //   arguments: response.data,
        // );
      }
    } on DioException catch (e) {
      debugPrint('Error Occurred: Getting Message');
      debugPrint(e.response?.data.toString());
      if (!context.mounted) return;
      alertErrorHandler(context, e.response?.data);
    }
  }

  //
}
