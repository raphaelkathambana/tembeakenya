import 'package:flutter/material.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';

var data = {
  "data": {
    "data": [
      {
        "id": 10,
        "firstName": "Charlotte",
        "lastName": "Goodwin",
        "username": "liza.king",
        "email": "kendall.schmeler@example.com",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 1,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 1,
        "following_count": 0
      }
    ],
    "meta": {
      "total": 1,
      "count": 1,
      "per_page": 10,
      "current_page": 1,
      "total_pages": 1
    }
  },
  "links": {
    "first": "http://localhost:8000/api/following?page=1",
    "last": "http://localhost:8000/api/following?page=1",
    "prev": null,
    "next": null
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 1,
    "links": [
      {"url": null, "label": "&laquo; Previous", "active": false},
      {
        "url": "http://localhost:8000/api/following?page=1",
        "label": "1",
        "active": true
      },
      {"url": null, "label": "Next &raquo;", "active": false}
    ],
    "path": "http://localhost:8000/api/following",
    "per_page": 10,
    "to": 1,
    "total": 1
  }
};

// loop through the data to get the list of users
List<User> getFriendDetails() {
  if (data['data']?['data'] != null) {
    List<User> users = [];
    var userData = data['data']?['data'] as List<Map<String, dynamic>>?;
    if (userData != null) {
      for (var user in userData) {
        users.add(User.fromJson(user));
      }
      return users;
    } else {
      return [
        User(
          id: 0,
          firstName: 'empty',
          lastName: 'empty',
          username: 'empty',
          email: 'empty',
          email_verified_at: DateTime(2024),
          roleNo: 1,
          image_id: 'empty',
          no_of_hikes: 0,
          total_distance_walked: 0,
          no_of_steps_taken: 0,
          followers_count: 0,
          following_count: 0,
        )
      ];
    }
  }
  return []; // Add a return statement here
}

// get the meta data
Map<String, Object?>? getMeta() {
  return data['meta'];
}

// check if the logged in user is following the friend
getFriend(int friendID) async {
  dynamic friends = [];
  late bool result;
  await CommunityController().getFollowing().then((values) {
    friends = values;
    for (var friend in friends) {
      debugPrint(friend.id.toString());
      if (friendID == friend.id) {
        result = true;
        break;
      } 
      else if (friendID != friend.id) {
        result = false;
      }
    }
  });
  return result;
}

List<User> getFollowingData(Map<String, dynamic> friendData) {
  if (friendData['data']?['data'] != null) {
    List<User> users = [];
    var userData = friendData['data']?['data'] as List<Map<String, dynamic>>?;
    if (userData != null) {
      for (var user in userData) {
        users.add(User.fromJson(user));
      }
      return users;
    } else {
      return [
        User(
          id: 0,
          firstName: 'empty',
          lastName: 'empty',
          username: 'empty',
          email: 'empty',
          email_verified_at: DateTime(2024),
          roleNo: 1,
          image_id: 'empty',
          no_of_hikes: 0,
          total_distance_walked: 0,
          no_of_steps_taken: 0,
          followers_count: 0,
          following_count: 0,
        )
      ];
    }
  }
  return []; // Add a return statement here
}
