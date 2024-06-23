// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tembeakenya/assets/user_detail.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final currentUser = FirebaseAuth.instance.currentUser!;

  // ****************************************** //

      // Uint8List? _image;
      // void selectImage() async {
      //   Uint8List img = await pickImage(ImageSource.gallery);
      //   setState(() {
      //     _image = img;
      //   });
      // }

    // ****************************************** //

      // Future<UserDetail> getCurrentUser(String email) async {
      //   final snapshot = await FirebaseFirestore.instance
      //       .collection("Users")
      //       .where("email", isEqualTo: currentUser.email)
      //       .get();
      //   final userData = snapshot.docs.map((e) => UserDetail.fromSnapshot(e)).single;
      //   return userData;
      // }

  // ****************************************** //

  @override
  Widget build(BuildContext context) {
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
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/editprofile/', (route)=>false),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Change Password'),
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/editprofile/', (route)=>false),
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
          
            // ****************************************** //
            child: FutureBuilder(
                future: UserDetail.getCurrentUser(currentUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      UserDetail userData = snapshot.data as UserDetail;
            // ****************************************** //

                      return Column(children: [
                        Card(
                          color: const Color.fromARGB(55, 99, 126, 32),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                                // _image != null ? IconButton(
                                //         icon: CircleAvatar(
                                //             radius: 42,
                                //             backgroundColor:
                                //                 ColorsUtil.accentColorDark,
                                //             child: CircleAvatar(
                                //               radius: 40,
                                //               backgroundImage:
                                //                   MemoryImage(_image!),
                                //             )),
                                //         // onPressed: selectImage,
                                //         onPressed: () {
                                //           showDialog(
                                //               context: context,
                                //               builder: (context) => AlertDialog(
                                //                       content: CircleAvatar(
                                //                         radius: 30,
                                //                         backgroundImage:
                                //                             MemoryImage(
                                //                                 _image!),
                                //                       ),
                                //                       actions: [
                                //                         TextButton(
                                //                           onPressed: () =>
                                //                               Navigator.of(
                                //                                       context)
                                //                                   .pop(),
                                //                           child:
                                //                               const Text('OK'),
                                //                         ),
                                //                       ]));
                                //         },
                                //       ):
                                  IconButton(
                                    icon: const CircleAvatar(
                                        radius: 42,
                                        backgroundColor:
                                            ColorsUtil.accentColorDark,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                              'lib/assets/images/profile.png'),
                                        )),
                                    // onPressed: selectImage,

                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => const AlertDialog(
                                            content:
                                                CircleAvatar(
                                                    radius: 140,
                                                    backgroundColor:
                                                        ColorsUtil
                                                            .accentColorDark,
                                                    child:
                                                        CircleAvatar(
                                                      radius: 138,
                                                      backgroundImage:
                                                          AssetImage(
                                                              'lib/assets/images/profile.png'),
                                                    )),
                                                    ));
                                    },
                                  ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${userData.fname} ${userData.lname}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsUtil.textColorDark)),
                                    Text(userData.username,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                ColorsUtil.secondaryColorDark)),
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
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 49, 59, 21),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                       Text('Email',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtil.primaryColorDark)),
                                      
                                    ],
                                  ),
                                  Text(currentUser.email!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorsUtil.textColorDark)),
                                ])),
                        Container(
                          height: 350,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 49, 59, 21),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(width: 30),

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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Number of Hikes',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                color: ColorsUtil
                                                    .primaryColorDark)),
                                        Row(
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            // mainAxisAlignment: MainAxisAlignment.spaceAround,

                                            children: [
                                              Text('1 ',
                                                  style: TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorsUtil
                                                          .textColorDark)),
                                              Text('hikes',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorsUtil
                                                          .textColorDark)),
                                            ])
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                        Container(
                          height: 350,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 0)),
                                Divider(
                                  height: 2,
                                  color: ColorsUtil.secondaryColorDark,
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 0)),

                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('There are no Milestones yet',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                color: ColorsUtil
                                                    .primaryColorDark)),
                                        Row(
                                            children: [
                                              Text(' ',
                                                  style: TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorsUtil
                                                          .textColorDark)),
                                              Text(' ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorsUtil
                                                          .textColorDark)),
                                            ])
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ]);
                    } else {
                      return const Center(child: Text('Error'),);
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                }))

        );
  }
}