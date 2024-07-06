import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_a_user.dart';

var data = [
  {
    "id": 1,
    "name": "quae",
    "description": "Harum enim dolores blanditiis nostrum quod.",
    "guide_id": 2
  },
  {
    "id": 2,
    "name": "quo",
    "description": "Est fugit quia nostrum.",
    "guide_id": 3
  },
  {
    "id": 3,
    "name": "nihil",
    "description": "Sunt provident ipsum voluptas vel nulla.",
    "guide_id": 4
  },
  {"id": 4, "name": "Deez Nuts", "description": "Zackary", "guide_id": 3},
  {
    "id": 5,
    "name": "Deez Nutsinyaface",
    "description": "Zackary Garmont",
    "guide_id": 2
  },
  {"id": 6, "name": "Gaudeamus", "description": "Igitur", "guide_id": 4}
];

var requests = [
  {
    "id": 1,
    "group_id": 3,
    "user_id": 1,
    "user": {
      "id": 1,
      "firstName": "Super",
      "lastName": "Admin",
      "username": "superadmin",
      "email": "codeclimberske@gmail.com",
      "email_verified_at": "2024-07-04T14:25:02.000000Z",
      "roleNo": 3,
      "image_id": "defaultProfilePic",
      "no_of_hikes": 0,
      "total_distance_walked": 0,
      "no_of_steps_taken": 0,
      "followers_count": 0,
      "following_count": 1
    },
    "created_at": "2024-07-05T23:15:24.000000Z",
    "updated_at": "2024-07-05T23:15:24.000000Z"
  },
  {
    "id": 2,
    "group_id": 3,
    "user_id": 12,
    "user": {
      "id": 12,
      "firstName": "Raph",
      "lastName": "Kath",
      "username": "raphaelkathambana",
      "email": "maya12raph@gmail.com",
      "email_verified_at": null,
      "roleNo": 1,
      "image_id": "defaultProfilePic",
      "no_of_hikes": 0,
      "total_distance_walked": 0,
      "no_of_steps_taken": 0,
      "followers_count": 0,
      "following_count": 0
    },
    "created_at": "2024-07-05T23:24:46.000000Z",
    "updated_at": "2024-07-05T23:24:46.000000Z"
  }
];

// loop through the data to get the list of members who've made a request to join a group
List<dynamic> getRequestData() {
  List<dynamic> requestsInfo = [];
  for (var request in data) {
    User user = getAUserDetails(request['user']);
    DateTime created = DateTime.parse(request['created_at'].toString());
    String requestedOn =
        'Requested on: ${created.day}/${created.month}/${created.year}';
    requestsInfo.add('${user.fullName} - $requestedOn');
    requestsInfo.add(user);
  }
  return requestsInfo;
}

List<dynamic> getGroupsFromData(data) {
  List<dynamic> groups = [];
  for (var group in data) {
    groups.add(group);
  }
  return groups;
}
