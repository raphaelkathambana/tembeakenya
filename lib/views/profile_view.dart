import 'dart:typed_data';
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
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

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
              onTap: () => Navigator.of(context).pushNamed('/editprofile/'),
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
                                _image != null
                                    ? IconButton(
                                        icon: CircleAvatar(
                                            radius: 42,
                                            backgroundColor:
                                                ColorsUtil.accentColorDark,
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundImage:
                                                  MemoryImage(_image!),
                                            )),
                                        // onPressed: selectImage,

                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      content: CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage:
                                                            MemoryImage(
                                                                _image!),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ]));
                                        },
                                      )
                                    : IconButton(
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
                                              builder: (context) => AlertDialog(
                                                      content:
                                                          const CircleAvatar(
                                                              radius: 120,
                                                              backgroundColor:
                                                                  ColorsUtil
                                                                      .accentColorDark,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 118,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'lib/assets/images/profile.png'),
                                                              )),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ]));
                                        },
                                      ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userData.fname,
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
                                // const Divider(
                                //   height: 2,
                                //   color: ColorsUtil.secondaryColorDark,
                                //   indent: 12,
                                //   endIndent: 12,
                                // ),
                              ]),
                        ),
                        Container(
                          height: 350,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: ColorsUtil.secondaryColorDark,
                              //   width: 3,
                              // ),
                              color: const Color.fromARGB(255, 49, 59, 21),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(width: 30),

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
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            // mainAxisAlignment: MainAxisAlignment.spaceAround,

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

        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,

        //   currentIndex: _currentIndex,
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },

        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.map),
        //       label: 'Navigation',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.people),
        //       label: 'Community',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //   ],
        // ),
        );
  }
}
