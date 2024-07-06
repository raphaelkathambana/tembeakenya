// import 'package:flutter/material.dart';
import 'package:tembeakenya/model/user.dart';

var data = {
  "data": {
    "data": [
      {
        "id": 1,
        "firstName": "Super",
        "lastName": "Admin",
        "username": "superadmin",
        "email": "codeclimberske@gmail.com",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 3,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 10,
        "total_distance_walked": 10,
        "no_of_steps_taken": 10,
        "followers_count": 0,
        "following_count": 1
      },
      {
        "id": 2,
        "firstName": "Destinee",
        "lastName": "Smith",
        "username": "goyette.herminia",
        "email": "qdare@example.net",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 2,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 3,
        "firstName": "Dannie",
        "lastName": "Raynor",
        "username": "carlee.dare",
        "email": "reilly.marilyne@example.org",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 2,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 4,
        "firstName": "Lindsay",
        "lastName": "Champlin",
        "username": "feil.milan",
        "email": "claudine.gleason@example.net",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 2,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 5,
        "firstName": "Lelia",
        "lastName": "Yundt",
        "username": "rice.rahsaan",
        "email": "toy71@example.net",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 1,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 6,
        "firstName": "Mervin",
        "lastName": "Turner",
        "username": "ryan.emerson",
        "email": "brice.bode@example.net",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 1,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 7,
        "firstName": "Jena",
        "lastName": "Emmerich",
        "username": "larson.frederik",
        "email": "mozelle.smith@example.net",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 1,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 8,
        "firstName": "Sunny",
        "lastName": "Stokes",
        "username": "antonette.thompson",
        "email": "schamberger.stanton@example.net",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 1,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
      {
        "id": 9,
        "firstName": "Katharina",
        "lastName": "Cassin",
        "username": "drew.frami",
        "email": "carlos.gusikowski@example.org",
        "email_verified_at": "2024-07-04T14:25:02.000000Z",
        "roleNo": 1,
        "image_id": "defaultProfilePic",
        "no_of_hikes": 0,
        "total_distance_walked": 0,
        "no_of_steps_taken": 0,
        "followers_count": 0,
        "following_count": 0
      },
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
      "total": 12,
      "count": 10,
      "per_page": 10,
      "current_page": 1,
      "total_pages": 2
    }
  },
  "links": {
    "first": "http://localhost:8000/api/users?page=1",
    "last": "http://localhost:8000/api/users?page=2",
    "prev": null,
    "next": "http://localhost:8000/api/users?page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 2,
    "links": [
      {"url": null, "label": "&laquo; Previous", "active": false},
      {
        "url": "http://localhost:8000/api/users?page=1",
        "label": "1",
        "active": true
      },
      {
        "url": "http://localhost:8000/api/users?page=2",
        "label": "2",
        "active": false
      },
      {
        "url": "http://localhost:8000/api/users?page=2",
        "label": "Next &raquo;",
        "active": false
      }
    ],
    "path": "http://localhost:8000/api/users",
    "per_page": 10,
    "to": 10,
    "total": 12
  }
};

// // loop through the data to get the list of users

// List<dynamic> getUsers() {
//   if (data['data']?['data'] != null) {
//     List<dynamic> users = [];
//     var userData = data['data']?['data'] as List<dynamic>?;
//     if (userData != null) {
//       for (var user in userData) {
//         users.add(user);
//       }
//       return users;
//     } else {
//       return ['empty'];
//     }
//   }
//   return []; // Add a return statement here
// }
// // load the retrieved users into the User model using the fromJson
// // method
// class User {
//   final int id;
//   final String firstName;
//   final String lastName;
//   final String username;
//   final String email;
//   final String emailVerifiedAt;
//   final int roleNo;
//   final String imageId;
//   final int noOfHikes;
//   final int totalDistanceWalked;
//   final int noOfStepsTaken;
//   final int followersCount;
//   final int followingCount;

//   User({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.username,
//     required this.email,
//     required this.emailVerifiedAt,
//     required this.roleNo,
//     required this.imageId,
//     required this.noOfHikes,
//     required this.totalDistanceWalked,
//     required this.noOfStepsTaken,
//     required this.followersCount,
//     required this.followingCount,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       username: json['username'],
//       email: json['email'],
//       emailVerifiedAt: json['email_verified_at'],
//       roleNo: json['roleNo'],
//       imageId: json['image_id'],
//       noOfHikes: json['no_of_hikes'],
//       totalDistanceWalked: json['total_distance_walked'],
//       noOfStepsTaken: json['no_of_steps_taken'],
//       followersCount: json['followers_count'],
//       followingCount: json['following_count'],
//     );
//   }
// }

// loop through the data to get the list of users
// List<User> getUsersFromDb() {
//   if (data['data']?['data'] != null) {
//     List<User> users = [];
//     var userData = data['data']?['data'] as List<Map<String, dynamic>>?;
//     if (userData != null) {
//       for (var user in userData) {
//         users.add(User.fromJson(user));
//       }
//       return users;
//     } else {
//       return [
//         User(
//           id: 0,
//           firstName: 'empty',
//           lastName: 'empty',
//           username: 'empty',
//           email: 'empty',
//           email_verified_at: DateTime(2024),
//           roleNo: 1,
//           image_id: 'empty',
//           no_of_hikes: 0,
//           total_distance_walked: 0,
//           no_of_steps_taken: 0,
//           followers_count: 0,
//           following_count: 0,
//         )
//       ];
//     }
//   }
//   return []; // Add a return statement here
// }

// check if a user is a hiker, a guide or an admin
String getRole(int roleNo) {
  switch (roleNo) {
    case 1:
      return 'Hiker';
    case 2:
      return 'Guide';
    case 3:
      return 'Admin';
    default:
      return 'Hiker';
  }
}

// check whether the user is allowed to edit (admin or guide) or not (hiker)
bool canEdit(int roleNo) {
  return roleNo != 1;
}

List<User> getUsersFromData(Map<String, dynamic> data) {
  if (data['data']?['data'] != null) {
    List<User> users = [];
    // var userData = data['data'] as List<Map<String, dynamic>>?;
    var userData = data['data']?['data'];
    if (userData != null) {
      for (var user in userData) {
        users.add(User.fromJson(user));
      }
      return users;
    }
  }
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
