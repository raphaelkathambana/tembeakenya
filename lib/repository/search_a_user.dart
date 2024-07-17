import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_users.dart';
import 'package:tembeakenya/views/people_detail_view.dart';

class UserService {
  Future<List<User>> fetchUsers(
      {required String searchQuery, int page = 1}) async {
    final queryParameters = {
      'search': searchQuery,
      'page': page.toString(),
    };

    final response = await APICall().client.get(
          '${url}api/users',
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
          ),
        );

    if (response.statusCode == 200) {
      return getListOfUsersFromData(response.data);
    } else {
      throw Exception('Failed to load users');
    }
  }
}

class UserListScreen extends StatefulWidget {
  final List<String> displayUrl;
  final List<bool?> isFriend;
  final List<bool> followsLoaded;
  final bool loaded;
  final User currentUser;
  const UserListScreen(
      {super.key,
      required this.displayUrl,
      required this.isFriend,
      required this.followsLoaded,
      required this.loaded,
      User? selectedUser,
      required this.currentUser});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService userService = UserService();
  List<User> users = [];
  int currentPage = 1;
  String searchQuery = '';
  late String? dropdownValue;
  List<String> userFilters = <String>['All', 'Follows'];
  late User selectedUser;

  @override
  void initState() {
    super.initState();
    dropdownValue = userFilters.first;
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final fetchedUsers = await userService.fetchUsers(
        searchQuery: searchQuery, page: currentPage);
    setState(() {
      users = fetchedUsers;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
    });
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Users'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const Divider(
                  height: 2,
                  color: ColorsUtil.secondaryColorDark,
                  indent: 12,
                  endIndent: 12,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * .90,
                  margin: const EdgeInsets.only(top: 20, bottom: 25),
                  height: 50,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: ColorsUtil.cardColorDark,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: onSearchChanged,
                          enableSuggestions: true,
                          autocorrect: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                            hintText: 'Search',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          style: const TextStyle(fontSize: 14),
                          underline: Container(height: 2),
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: userFilters
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (users[index].id == widget.currentUser.id) {
            return const SizedBox();
          }
          if (dropdownValue == userFilters.last) {
            if (widget.isFriend[index] == true) {
              return ListTile(
                  // title:
                  //     Text('${users[index].firstName} ${users[index].lastName}'),
                  // subtitle: Text(users[index].email!),
                  title: userCard(users, index));
            } else {
              return const SizedBox();
            }
          } else {
            return ListTile(
                // title: Text('${users[index].firstName} ${users[index].lastName}'),
                // subtitle: Text(users[index].email!),
                title: userCard(users, index));
          }
        },
      ),
    );
  }

  userCard(theUsers, int num) {
    return TextButton(
      onPressed: () async {
        await CommunityController().getAUsersDetails(theUsers[num].id).then(
          (user) {
            setState(() {
              selectedUser = user;
            });
          },
        );

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PeopleDetailView(
              selectedUser: selectedUser,
              currentUser: widget.currentUser,
            ),
          ),
        );
      },
      style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent)),
      child: Card(
        color: ColorsUtil.cardColorDark,
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        child: Column(
          children: [
            const Divider(
              height: 2,
              color: ColorsUtil.secondaryColorDark,
              indent: 12,
              endIndent: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                !widget.loaded
                    ? Row(
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            child: CircleAvatar(
                              radius: 37,
                              backgroundColor: ColorsUtil.cardColorDark,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 230,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  height: 20,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorsUtil.cardColorDark,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorsUtil.cardColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 3.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorsUtil.cardColorDark,
                            ),
                            height: 35,
                            width: 95,
                          )
                        ],
                      )
                    : Row(
                        children: [
                          if (widget.displayUrl[num].isEmpty)
                            const CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              child: CircleAvatar(
                                radius: 37,
                                backgroundColor: ColorsUtil.accentColorDark,
                                child: CircleAvatar(
                                  radius: 35,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          else
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              child: CircleAvatar(
                                radius: 37,
                                backgroundColor: ColorsUtil.accentColorDark,
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      NetworkImage(widget.displayUrl[num]),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 230,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Text(
                                    theUsers[num].fullName,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: ColorsUtil.textColorDark),
                                  ),
                                ),
                                Text(
                                  '@${theUsers[num].username}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: ColorsUtil.accentColorDark),
                                ),
                              ],
                            ),
                          ),
                          widget.isFriend[num]!
                              ? Container(
                                  margin: const EdgeInsets.only(right: 3.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorsUtil.accentColorDark),
                                  height: 35,
                                  width: 95,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.isFriend[num] =
                                            !widget.isFriend[num]!;
                                        CommunityController()
                                            .unFollowUser(num + 1, context);
                                      });
                                    },
                                    child: const Text(
                                      'Following',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorsUtil.textColorDark),
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(right: 3.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorsUtil.secondaryColorDark),
                                  height: 35,
                                  width: 95,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.isFriend[num] =
                                            !widget.isFriend[num]!;
                                        CommunityController()
                                            .followUser(num + 1, context);
                                      });
                                    },
                                    child: const Text(
                                      'Follow',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorsUtil.textColorDark),
                                    ),
                                  ),
                                )
                        ],
                      ),
              ],
            ),
            const Divider(
              height: 2,
              color: ColorsUtil.secondaryColorDark,
              indent: 12,
              endIndent: 12,
            ),
          ],
        ),
      ),
    );
  }
}
