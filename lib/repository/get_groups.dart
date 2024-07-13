import 'package:tembeakenya/controllers/community_controller.dart';
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
      "role_id": 3,
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
      "email_verified_at": '2024-07-04T14:25:02.000000Z',
      "role_id": 1,
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
var aGroupsData = {
  "id": 1,
  "name": "illum",
  "description": "Debitis deserunt voluptas dicta nesciunt debitis.",
  "guide_id": 2,
  "image_id": "defaultProfilePic",
  "members": [
    {
      "id": 2,
      "firstName": "Bailee",
      "lastName": "Wintheiser",
      "username": "mylene.treutel",
      "email": "oswaldo.kohler@example.net",
      "email_verified_at": "2024-07-10T12:17:19.000000Z",
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
      "email_verified_at": "2024-07-10T12:17:18.000000Z",
      "role_id": 3,
      "image_id": "defaultProfilePic",
      "no_of_hikes": 0,
      "total_distance_walked": 0,
      "no_of_steps_taken": 0,
      "followers_count": 0,
      "following_count": 0
    },
    {
      "id": 5,
      "firstName": "Mike",
      "lastName": "Kuhic",
      "username": "kcormier",
      "email": "weimann.rafael@example.com",
      "email_verified_at": "2024-07-10T12:17:20.000000Z",
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
      "firstName": "Rahsaan",
      "lastName": "Swift",
      "username": "lbayer",
      "email": "rbayer@example.net",
      "email_verified_at": "2024-07-10T12:17:20.000000Z",
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
      "firstName": "Noble",
      "lastName": "Green",
      "username": "rosalee04",
      "email": "luigi.lind@example.com",
      "email_verified_at": "2024-07-10T12:17:20.000000Z",
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
      "firstName": "Katlynn",
      "lastName": "Schmeler",
      "username": "qpouros",
      "email": "stanton.merle@example.com",
      "email_verified_at": "2024-07-10T12:17:21.000000Z",
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
      "firstName": "Sibyl",
      "lastName": "Deckow",
      "username": "jsmitham",
      "email": "barmstrong@example.org",
      "email_verified_at": "2024-07-10T12:17:21.000000Z",
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
      "firstName": "Izaiah",
      "lastName": "Hamill",
      "username": "kcremin",
      "email": "jconsidine@example.com",
      "email_verified_at": "2024-07-10T12:17:21.000000Z",
      "role_id": 1,
      "image_id": "defaultProfilePic",
      "no_of_hikes": 0,
      "total_distance_walked": 0,
      "no_of_steps_taken": 0,
      "followers_count": 0,
      "following_count": 0
    }
  ],
  "group-hikes": [
    {
      "id": 1,
      "name": "Abadare Part 5, 7 Ponds",
      "description": "Molestiae ipsa nihil rerum id deleniti.",
      "group_id": 1,
      "hike_id": 1,
      "guide_id": 2,
      "hike_date": "2024-07-12"
    }
  ]
};
var groupHikeDetails = {
  "id": 1,
  "name": "Abadare Part 5, 7 Ponds",
  "description": "Molestiae ipsa nihil rerum id deleniti.",
  "group_id": 1,
  "hike_id": 1,
  "guide_id": 2,
  "hike_date": "2024-07-12",
  "group": {
    "id": 1,
    "name": "illum",
    "description": "Debitis deserunt voluptas dicta nesciunt debitis.",
    "guide_id": 2,
    "image_id": "defaultProfilePic"
  },
  "hike": {
    "id": 1,
    "name": "occaecati",
    "map_data": "{\"map\":\"data\"}",
    "distance": 9.47,
    "estimated_duration": "2024-07-12T16:05:17.000000Z",
    "group_id": 2,
    "user_id": 5
  },
  "guide": {
    "id": 2,
    "firstName": "Bailee",
    "lastName": "Wintheiser",
    "username": "mylene.treutel",
    "email": "oswaldo.kohler@example.net",
    "email_verified_at": "2024-07-10T12:17:19.000000Z",
    "role_id": 2,
    "image_id": "defaultProfilePic",
    "no_of_hikes": 0,
    "total_distance_walked": 0,
    "no_of_steps_taken": 0,
    "followers_count": 0,
    "following_count": 0
  },
  "attendees": [
    {
      "id": 1,
      "group_hike_id": 1,
      "user_id": 2,
      "name": "Bailee Wintheiser",
      "phone_number": "469.225.7218",
      "email": "oswaldo.kohler@example.net",
      "emergency_contact": "Emergency Contact for Bailee"
    },
    {
      "id": 2,
      "group_hike_id": 1,
      "user_id": 1,
      "name": "Super Admin",
      "phone_number": "571.525.8306",
      "email": "codeclimberske@gmail.com",
      "emergency_contact": "Emergency Contact for Super"
    },
    {
      "id": 3,
      "group_hike_id": 1,
      "user_id": 5,
      "name": "Mike Kuhic",
      "phone_number": "+1-216-657-1079",
      "email": "weimann.rafael@example.com",
      "emergency_contact": "Emergency Contact for Mike"
    },
    {
      "id": 4,
      "group_hike_id": 1,
      "user_id": 6,
      "name": "Rahsaan Swift",
      "phone_number": "276.332.9561",
      "email": "rbayer@example.net",
      "emergency_contact": "Emergency Contact for Rahsaan"
    },
    {
      "id": 5,
      "group_hike_id": 1,
      "user_id": 7,
      "name": "Noble Green",
      "phone_number": "+1.229.998.9866",
      "email": "luigi.lind@example.com",
      "emergency_contact": "Emergency Contact for Noble"
    },
    {
      "id": 6,
      "group_hike_id": 1,
      "user_id": 8,
      "name": "Katlynn Schmeler",
      "phone_number": "+1.616.239.6485",
      "email": "stanton.merle@example.com",
      "emergency_contact": "Emergency Contact for Katlynn"
    },
    {
      "id": 7,
      "group_hike_id": 1,
      "user_id": 9,
      "name": "Sibyl Deckow",
      "phone_number": "845.916.3691",
      "email": "barmstrong@example.org",
      "emergency_contact": "Emergency Contact for Sibyl"
    },
    {
      "id": 8,
      "group_hike_id": 1,
      "user_id": 10,
      "name": "Izaiah Hamill",
      "phone_number": "1-239-970-7034",
      "email": "jconsidine@example.com",
      "emergency_contact": "Emergency Contact for Izaiah"
    }
  ]
};
// loop through the data to get the list of members who've made a request to join a group
Map<String, User> getRequestData(requestsData) {
  Map<String, User> requestsInfo = {};
  for (var request in requestsData) {
    User user = getAUserDetails(request['user']);
    DateTime created = DateTime.parse(request['created_at'].toString());
    String requestedOn =
        'Requested on: ${created.day}/${created.month}/${created.year}';
    // requestsInfo?.add('${user.fullName} - $requestedOn');
    final listing = <String, User>{'${user.fullName} - $requestedOn': user};
    requestsInfo.addEntries(listing.entries);
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

List<User> getMembersData(data) {
  List<User> membersInfo = [];
  if (data['members'] != null) {
    for (var member in (data['members'] ?? []) as Iterable) {
      User user = getAUserDetails(member);
      final listing = user;
      membersInfo.add(listing);
    }
  }
  return membersInfo;
}

List<dynamic> getGroupHikesData(data) {
  List<dynamic> groupHikesInfo = [];
  if (data['group-hikes'] != null) {
    for (var hike in (data['group-hikes'] ?? []) as Iterable) {
      final listing = hike;
      groupHikesInfo.add(listing);
    }
  }
  return groupHikesInfo;
}

List<dynamic> getEventHikesDetails(data) {
  List<dynamic> groupHikesInfo = [];
  groupHikesInfo.add(data['id']);
  groupHikesInfo.add(data['name']);
  groupHikesInfo.add(data['description']);
  groupHikesInfo.add(data['group_id']);
  groupHikesInfo.add(data['guide_id']);
  groupHikesInfo.add(data['hike_id']);
  groupHikesInfo.add(data['hike_date']);
  return groupHikesInfo;
}

Future<Map<User, dynamic>> getAttendeesData(data) async {
  Map<User, dynamic> attendeesInfo = {};
  List<dynamic> attendeeInfo = [];
  if (data['attendees'] != null) {
    for (var attendee in (data['attendees'] ?? []) as Iterable) {
      final listing = attendee;
      attendeeInfo.add(listing);
    }
  }
  if (data['attendees'] != null) {
    int i = 0;
    for (var attendee in (data['attendees'] ?? []) as Iterable) {
      User user =
          await CommunityController().getAUsersDetails(attendee['user_id']);
      final listing = user;
      var entry = <User, dynamic>{listing: attendeeInfo.elementAt(i)};
      attendeesInfo.addEntries(entry.entries);
      i++;
    }
  }
  return attendeesInfo;
}

List<dynamic> getHikeDetails(data) {
  List<dynamic> hike = [];
  if (data['hike'] != null) {
    List<dynamic> hikeInfo = [];
    hikeInfo.add(data['hike']['id']);
    hikeInfo.add(data['hike']['name']);
    hikeInfo.add(data['hike']['map_data']);
    hikeInfo.add(data['hike']['distance']);
    hikeInfo.add(data['hike']['estimated_duration']);
    hike.add(hikeInfo);
  }
  return hike;
}
