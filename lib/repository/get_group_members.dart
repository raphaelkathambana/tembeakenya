import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';

var data = [
  {
    "id": 2,
    "firstName": "Destinee",
    "lastName": "Smith",
    "username": "goyette.herminia",
    "email": "qdare@example.net",
    "email_verified_at": "2024-07-04T14:25:02.000000Z",
    "role_id": 2,
    "image_id": "defaultProfilePic",
    "no_of_hikes": 0,
    "total_distance_walked": 0,
    "no_of_steps_taken": 0,
    "followers_count": 0,
    "following_count": 0
  },
  {
    "id": 1,
    "firstName": "Super",
    "lastName": "Admin",
    "username": "superadmin",
    "email": "codeclimberske@gmail.com",
    "email_verified_at": "2024-07-04T14:25:02.000000Z",
    "role_id": 3,
    "image_id": "defaultProfilePic",
    "no_of_hikes": 0,
    "total_distance_walked": 0,
    "no_of_steps_taken": 0,
    "followers_count": 0,
    "following_count": 1
  },
  {
    "id": 5,
    "firstName": "Lelia",
    "lastName": "Yundt",
    "username": "rice.rahsaan",
    "email": "toy71@example.net",
    "email_verified_at": "2024-07-04T14:25:02.000000Z",
    "role_id": 1,
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
    "role_id": 1,
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
    "role_id": 1,
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
    "role_id": 1,
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
    "role_id": 1,
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
    "role_id": 1,
    "image_id": "defaultProfilePic",
    "no_of_hikes": 0,
    "total_distance_walked": 0,
    "no_of_steps_taken": 0,
    "followers_count": 1,
    "following_count": 0
  }
];

// loop through the data to get the list of users and load them into the user Model
List<User> getGroupMembers() {
  List<User> users = [];
  for (var user in data) {
    users.add(User.fromJson(user));
  }
  return users;
}

// check if the user is a member of the group
bool isGroupMember(User user) {
  // var user = getUsersFromDb()[userId];
  List<User> members = getGroupMembers();
  for (var member in members) {
    if (user.id == member.id) {
      return true;
    }
  }
  return false;
}

// check if user has requested to join a group
Future<bool> hasRequestedToJoinGroup(User user, int groupId) async {
  // var user = getUsersFromDb()[userId];
  Map<String, User> data = await CommunityController().getJoinRequests(groupId);
  for (var request in data.entries) {
    if (user.id == request.value.id) {
      return true;
    }
  }
  return false;
}
// bool getFriends(int num) {
//   var user = getUsersFromDb()[num];
//   List<User> friends = getFriendDetails();
//   for (var friend in friends) {
//     if (friend.id == user.id) {
//       return true;
//     }
//   }
//   return false;
// }
