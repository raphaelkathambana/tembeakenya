import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_storage.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String displayUrl;

  // ****ALL DATA HERE SHALL BE RETRIEVED FROM THE DB ***** //

  String firstName = "Bethelhem";
  String lastName = "Tesfaye";
  String username = "@JustMeHopeless";
  String email = "BethelhemTesfaye95@gmail.com";
  /*
     In the database, when creating a new user, the user shall have 
     "defaultProfilePic" as the imageID, then when a user chooses 
     a new profile picture, a new name will be generated.

     This new name will consists of the format "${username}ProfilePic"

     But since we dont have a database that can update the name, 
     this code will only save images as "defaultProfilePic" 
     despite the changes made
    */
  String profileImageID = "defaultProfilePic";

  // ****************************************************** //
  @override
  void initState() {
    displayUrl = '';

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    debugPrint('Ok, Image URL: $displayUrl');

    NavigationService navigationService = NavigationService(router);
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
              onTap: () => navigationService.navigateToEditProfile(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Change Password'),
              onTap: () => navigationService.navigateToEditProfile(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/welcome/', (route) => false);
              },
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
                    child: 
                    CircleAvatar(
                    radius: 42,
                    backgroundColor: ColorsUtil.accentColorDark,
                    child: CircleAvatar(
                      radius: 40,
                      child: CircularProgressIndicator(),
                    )
                  ))                  
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
                            builder: (context) => AlertDialog(
                                  content: CircleAvatar(
                                      radius: 140,
                                      backgroundColor:
                                          ColorsUtil.accentColorDark,
                                      child: CircleAvatar(
                                        radius: 138,
                                        backgroundImage:
                                            NetworkImage(displayUrl),
                                      )),
                                ));
                      },
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$firstName $lastName",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorsUtil.textColorDark)),

                      Text(username,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.secondaryColorDark)),
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
                    Text(email,
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
                          ])
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
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Milestones',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorsUtil.primaryColorDark)),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
                  Divider(
                    height: 2,
                    color: ColorsUtil.secondaryColorDark,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 0)),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('There are no Milestones yet',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.primaryColorDark)),
                          Row(children: [
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
        ])
            ));
  }
}
