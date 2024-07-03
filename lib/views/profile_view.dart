import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/model/user.dart';

class ProfileView extends StatefulWidget {
  final dynamic currentUser;
  const ProfileView({super.key, required this.currentUser, required user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String displayUrl;
  User? user;
  late NavigationService navigationService;
  bool _isLoading = false;
  /*
     In the database, when creating a new user, the user shall have 
     "defaultProfilePic" as the imageID, then when a user chooses 
     a new profile picture, a new name will be generated.

     This new name will consists of the format "${username}ProfilePic"

     But since we don't have a database that can update the name, 
     this code will only save images as "defaultProfilePic" 
     despite the changes made
    */
  String profileImageID = "";

  // ****************************************************** //
  @override
  void initState() {
    navigationService = NavigationService(router);
    user = widget.currentUser;
    profileImageID = "${user!.image_id}";
    displayUrl = '';
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    debugPrint('Ok, Image URL: $displayUrl');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(57, 22, 26, 15),
          title: const Text(
            'Profile Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        endDrawer: Drawer(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () =>
                  navigationService.navigatePushToEditProfile(context, user),
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Change Password'),
              onTap: () =>
                  // todo implement change password page
                  navigationService.navigatePushToChangePassword(context, user),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: _isLoading ? null : _handleLogout,
            ),
          ]),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Card(
            color: const Color.fromARGB(55, 99, 126, 32),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(children: [
              const Divider(
                height: 2,
                color: ColorsUtil.secondaryColorDark,
                indent: 12,
                endIndent: 12,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  if (displayUrl.isEmpty)
                    const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0x00000000),
                        child: CircleAvatar(
                            radius: 42,
                            backgroundColor: ColorsUtil.accentColorDark,
                            child: CircleAvatar(
                              radius: 40,
                              child: CircularProgressIndicator(),
                            )))
                  else
                    IconButton(
                      icon: CircleAvatar(
                          radius: 42,
                          backgroundColor: ColorsUtil.accentColorDark,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(displayUrl),
                          )),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Container(
                                  padding: const EdgeInsets.all(15),
                                  child: CircleAvatar(
                                      radius: MediaQuery.sizeOf(context).width,
                                      backgroundColor:
                                          ColorsUtil.accentColorDark,
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.sizeOf(context).width *
                                                .45,
                                        backgroundImage:
                                            NetworkImage(displayUrl),
                                      )),
                                ));
                      },
                    ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          child: Text(user!.fullName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark)),
                        ),
                        Text('@${user!.username.toString()}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.accentColorDark)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 2,
                color: ColorsUtil.secondaryColorDark,
                indent: 12,
                endIndent: 12,
              ),
            ]),
          ),

          // Email
          Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 59, 21),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Email',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                      ],
                    ),
                    Text(user!.email.toString(),
                        style: const TextStyle(
                            fontSize: 18, color: ColorsUtil.textColorDark)),
                  ])),

          // Statistic has dummy writing
          Container(
            height: 350,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 59, 21),
                borderRadius: BorderRadius.circular(10)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statistics',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark)),
                  Divider(
                    height: 15,
                    color: ColorsUtil.secondaryColorDark,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Number of Hikes',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.primaryColorDark)),
                          Row(children: [
                            Text('1 ',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.textColorDark)),
                            Text('hikes',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: ColorsUtil.textColorDark)),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ]),
          ),

          // Milestone has dummy writing
          Container(
            height: 350,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 59, 21),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Milestones',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorsUtil.primaryColorDark)),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
              const Divider(
                height: 2,
                color: ColorsUtil.secondaryColorDark,
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width * .7,
                          child: const Text('There are no Milestones yet',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.primaryColorDark))),
                      const Row(children: [
                        Text(' ',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.textColorDark)),
                        Text(' ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: ColorsUtil.textColorDark)),
                      ])
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ])));
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    bool isLoggedOut = await AuthController(navigationService).logout();

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    if (isLoggedOut) {
      // Navigate to the login or welcome screen
      if (!mounted) return;
      // context.go('/login');
      navigationService.navigateToLogin(context);
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
  }
}
