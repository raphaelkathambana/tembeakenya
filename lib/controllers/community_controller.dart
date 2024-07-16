import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_a_user.dart';
// import 'package:tembeakenya/repository/get_following.dart';
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

  Future<void> followUser(int id, BuildContext context) async {
    try {
      var response = await apiCall.client.post('${url}api/users/$id/follow');
      if (response.statusCode == 200) {
        debugPrint('Successfully Followed');
        if (!context.mounted) return;
        await context.watch<AuthController>().refreshUserDetails();
        await onRefresh();
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  Future<void> unFollowUser(int id, BuildContext context) async {
    try {
      var response = await apiCall.client.post('${url}api/users/$id/unfollow');
      if (response.statusCode == 200) {
        debugPrint('Successfully Unfollowed');
        if (!context.mounted) return;
        await context.watch<AuthController>().refreshUserDetails();
        await onRefresh();
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
    await getCommunityData();
  }

  getFollowing() async {
    try {
      var response = await apiCall.client.get('${url}api/following');
      if (response.statusCode == 200) {
        return getUsersFromData(response.data);
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  getFollowers() async {
    try {
      var response = await apiCall.client.get('${url}api/followers');
      if (response.statusCode == 200) {
        return getUsersFromData(response.data);
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
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

  Future<Map<String, dynamic>> getGroupDetails(int id) async {
    try {
      var response = await apiCall.client.get('${url}api/groups/$id');
      if (response.statusCode == 200) {
        var members = getMembersData(response.data);
        var events = getGroupHikesData(response.data);
        return {
          'members': members,
          'events': events,
        };
      } else {
        return {};
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      return {};
    }
  }

  Future<Map<String, dynamic>> getGroupHikesDetails(int id) async {
    try {
      var response = await apiCall.client.get('${url}api/group-hikes/$id');
      if (response.statusCode == 200) {
        var groupHikeDetails = getEventHikesDetails(response.data);
        var attendees = await getAttendeesData(response.data);
        var hike = getHikeDetails(response.data);
        return {
          'groupHikeDetails': groupHikeDetails,
          'attendees': attendees,
          'hike': hike,
        };
      } else {
        return {};
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      return {};
    }
  }

  // update group details
  Future<void> updateGroupDetails(int groupId, int guideId, String name,
      String description, String imageId, BuildContext context) async {
    String token = await getCsrfToken();
    try {
      var response = await apiCall.client.put('${url}api/groups/$groupId',
          data: jsonEncode({
            'name': name,
            'description': description,
            'guide_id': guideId,
            'image_id': imageId,
          }),
          options: Options(headers: {
            'X-XSRF-TOKEN': token,
            'Accept': 'application/json',
          }));
      if (response.statusCode == 200) {
        // snackbar for created successfully
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group updated successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        // delay 3 seconds
        // await Future.delayed(const Duration(seconds: 1));
        // return to group view
        if (!context.mounted) return;
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
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

  // request to join group
  Future<void> requestToJoinGroup(int id, BuildContext context) async {
    try {
      var response =
          await apiCall.client.post('${url}api/groups/{$id}/request-to-join');
      if (response.statusCode == 200) {
        debugPrint('Successfully Requested');
        if (!context.mounted) return;
        await context.watch<AuthController>().refreshUserDetails();
        await onRefresh();
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // get the join requests
  Future<Map<String, User>> getJoinRequests(int id) async {
    try {
      var response =
          await apiCall.client.get('${url}api/groups/$id/join-requests');
      if (response.statusCode == 200) {
        return getRequestData(response.data);
      } else {
        return {};
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
      return {};
    }
  }

  // approve join request
  Future<void> approveJoinRequest(
      int groupId, int userId, BuildContext context) async {
    try {
      var response = await apiCall.client
          .post('${url}api/groups/{$groupId}/approve-member/{$userId}');
      if (response.statusCode == 200) {
        debugPrint('Successfully Approved');
        if (!context.mounted) return;
        await context.watch<AuthController>().refreshUserDetails();
        await onRefresh();
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // reject join request
  Future<void> rejectJoinRequest(
      int groupId, int userId, BuildContext context) async {
    try {
      var response = await apiCall.client
          .post('${url}api/groups/{$groupId}/reject-member/{$userId}');
      if (response.statusCode == 200) {
        debugPrint('Successfully Rejected');
        if (!context.mounted) return;
        await context.watch<AuthController>().refreshUserDetails();
        await onRefresh();
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // signing up to join a group hike
  Future<void> signUpForGroupHike(
      int groupHikeId,
      int userId,
      String name,
      String phoneNumber,
      String email,
      String emergencyContact,
      BuildContext context) async {
    String token = await getCsrfToken();
    try {
      var response = await apiCall.client.post('${url}api/group-hike-attendees',
          data: jsonEncode({
            'group_hike_id': groupHikeId,
            'user_id': userId,
            'name': name,
            'phone_number': phoneNumber,
            'email': email,
            'emergency_contact': emergencyContact,
          }),
          options: Options(headers: {
            'X-XSRF-TOKEN': token,
            'Accept': 'application/json',
          }));
      if (response.statusCode == 200) {
        debugPrint('Details Saved... Awaiting Payment');
        if (!context.mounted) return;
        await context.watch<AuthController>().refreshUserDetails();
        await onRefresh();
      }
    } on DioException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  // Future<void> joinGroup(int id, BuildContext context) async {
  //   try {
  //     var response = await apiCall.client.post('${url}api/groups/$id/join');
  //     if (response.statusCode == 200) {
  //       debugPrint('Successfully Joined');
  //       if (!context.mounted) return;
  //       await context.watch<AuthController>().refreshUserDetails();
  //       await onRefresh();
  //     }
  //   } on DioException catch (e) {
  //     debugPrint('Error: ${e.message}');
  //   }
  // }

  // Future<void> leaveGroup(int id, BuildContext context) async {
  //   try {
  //     var response = await apiCall.client.post('${url}api/groups/$id/leave');
  //     if (response.statusCode == 200) {
  //       debugPrint('Successfully Left');
  //       if (!context.mounted) return;
  //       await context.watch<AuthController>().refreshUserDetails();
  //       await onRefresh();
  //     }
  //   } on DioException catch (e) {
  //     debugPrint('Error: ${e.message}');
  //   }
  // }

  // Future<void> joinGroupHike(int id, BuildContext context) async {
  //   try {
  //     var response =
  //         await apiCall.client.post('${url}api/group-hikes/$id/join');
  //     if (response.statusCode == 200) {
  //       debugPrint('Successfully Joined');
  //       if (!context.mounted) return;
  //       await context.watch<AuthController>().refreshUserDetails();
  //       await onRefresh();
  //     }
  //   } on DioException catch (e) {
  //     debugPrint('Error: ${e.message}');
  //   }
  // }

  // Future<void> leaveGroupHike(int id, BuildContext context) async {
  //   try {
  //     var response =
  //         await apiCall.client.post('${url}api/group-hikes/$id/leave');
  //     if (response.statusCode == 200) {
  //       debugPrint('Successfully Left');
  //       if (!context.mounted) return;
  //       await context.watch<AuthController>().refreshUserDetails();
  //       await onRefresh();
  //     }
  //   } on DioException catch (e) {
  //     debugPrint('Error: ${e.message}');
  //   }
  // }

  Future<void> createGroupHike(String name, String description, double fee, String hikeId,
      String date, int groupID, int guideId, BuildContext context) async {
    debugPrint(name);
    debugPrint(description);
    debugPrint(fee.toString());
    debugPrint(hikeId);
    debugPrint(date);
    debugPrint(groupID.toString());
    debugPrint(guideId.toString());
    String token = await getCsrfToken();
    try {
      var response = await apiCall.client.post('${url}api/group-hikes',
          data: jsonEncode({
            'name': name,
            'description': description,
            'hike_fee': fee,
            'hike_id': hikeId,
            'group_id': groupID,
            'hike_date': date,
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
            content: Text('Group Hike created successfully'),
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

  // Future<void> deleteGroupHike(int id, BuildContext context) async {
  //   String token = await getCsrfToken();
  //   try {
  //     var response = await apiCall.client.delete('${url}api/group-hikes/$id',
  //         options: Options(headers: {
  //           'X-XSRF-TOKEN': token,
  //           'Accept': 'application/json',
  //         }));
  //     if (response.statusCode == 200) {
  //       // snackbar for created successfully
  //       if (!context.mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Group Hike deleted successfully'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //       // delay 3 seconds
  //       await Future.delayed(const Duration(seconds: 1));
  //       // return to group view
  //       if (!context.mounted) return;
  //       context.pop();
  //       // navigationService.navigateTo(
  //       //   '',
  //       //   arguments: response.data,
  //       // );
  //     }
  //   } on DioException catch (e) {
  //     debugPrint('Error Occurred: Getting Message');
  //     debugPrint(e.response?.data.toString());
  //     if (!context.mounted) return;
  //     alertErrorHandler(context, e.response?.data);
  //   }
  // }

  // Future<void> deleteGroup(int id, BuildContext context) async {
  //   String token = await getCsrfToken();
  //   try {
  //     var response = await apiCall.client.delete('${url}api/groups/$id',
  //         options: Options(headers: {
  //           'X-XSRF-TOKEN': token,
  //           'Accept': 'application/json',
  //         }));
  //     if (response.statusCode == 200) {
  //       // snackbar for created successfully
  //       if (!context.mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Group deleted successfully'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //       // delay 3 seconds
  //       await Future.delayed(const Duration(seconds: 1));
  //       // return to group view
  //       if (!context.mounted) return;
  //       context.pop();
  //       // navigationService.navigateTo(
  //       //   '',
  //       //   arguments: response.data,
  //       // );
  //     }
  //   } on DioException catch (e) {
  //     debugPrint('Error Occurred: Getting Message');
  //     debugPrint(e.response?.data.toString());
  //     if (!context.mounted) return;
  //     alertErrorHandler(context, e.response?.data);
  //   }
  // }
}
