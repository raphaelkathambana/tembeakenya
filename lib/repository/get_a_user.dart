import 'package:tembeakenya/model/user.dart';

var data = {
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
  "following_count": 0,
  "reviews": [
    {
      "id": 6,
      "user_id": 10,
      "hike_id": 1,
      "review": "Voluptas ab dolorum explicabo sint omnis.",
      "rating": 1
    },
    {
      "id": 12,
      "user_id": 10,
      "hike_id": 2,
      "review": "Tempore assumenda repudiandae rerum eveniet.",
      "rating": 4
    }
  ]
};

// loop through the data to get the User details and the Review details
User getUserDetails() {
  User user = User();
  user.id = data['id'] as int?;
  user.firstName = data['firstName'] as String?;
  user.lastName = data['lastName'] as String?;
  user.username = data['username'] as String?;
  user.email = data['email'] as String?;
  user.email_verified_at = DateTime.parse(data['email_verified_at'] as String);
  user.roleNo = data['roleNo'] as int?;
  // user.image_id = data['image_id'];
  user.no_of_hikes = data['no_of_hikes'] as int?;
  user.total_distance_walked = data['total_distance_walked'] as int?;
  user.no_of_steps_taken = data['no_of_steps_taken'] as int?;
  user.followers_count = data['followers_count'] as int?;
  user.following_count = data['following_count'] as int?;
  return user;
}

getReviews() {
  // var reviews = [];
  // for (var review in (data['reviews'] ?? []) as List) {
  //   reviews.add(review);
  // }
  var reviews = {};
  for (var review in (data['reviews'] ?? []) as List) {
    reviews.addEntries({
      MapEntry(
        review['id'],
        {
          "user_id": review['user_id'],
          "hike_id": review['hike_id'],
          "review": review['review'],
          "rating": review['rating']
        },
      ),
    });
  }
  return reviews;
}

User getAUserDetails(data) {
  User user = User();
  user.id = data['id'] as int?;
  user.firstName = data['firstName'] as String?;
  user.lastName = data['lastName'] as String?;
  user.username = data['username'] as String?;
  user.email = data['email'] as String?;
  user.email_verified_at = DateTime.parse(data['email_verified_at'] as String);
  user.roleNo = data['roleNo'] as int?;
  user.profileImageId = data['image_id'] as String?;
  user.no_of_hikes = data['no_of_hikes'] as int?;
  user.total_distance_walked = data['total_distance_walked'] as int?;
  user.no_of_steps_taken = data['no_of_steps_taken'] as int?;
  user.followers_count = data['followers_count'] as int?;
  user.following_count = data['following_count'] as int?;
  return user;
}
