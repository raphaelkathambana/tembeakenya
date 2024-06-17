import 'dart:typed_data';

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

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Edit Profile Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: UserDetail.getCurrentUser(currentUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      UserDetail userData = snapshot.data as UserDetail;
                      // ****************************************** //
                      return Column(children: [
                        Column(children: [
                          _image != null
                              ? Stack(children: [
                                  IconButton(
                                      icon: CircleAvatar(
                                          radius: 62,
                                          backgroundColor:
                                              ColorsUtil.accentColorDark,
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundImage:
                                                MemoryImage(_image!),
                                          )),
                                      onPressed: selectImage),
                                  const Positioned(
                                    bottom: 10,
                                    left: 100,
                                    child: Icon(Icons.add_a_photo),
                                  )
                                ])
                              : Stack(children: [
                                  IconButton(
                                    icon: const CircleAvatar(
                                        radius: 62,
                                        backgroundColor:
                                            ColorsUtil.accentColorDark,
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundImage: AssetImage(
                                              'lib/assets/images/profile.png'),
                                        )),
                                    onPressed: selectImage,
                                  ),
                                  const Positioned(
                                    bottom: 10,
                                    left: 100,
                                    child: Icon(Icons.add_a_photo),
                                  )
                                ]),
                          const Divider(
                            height: 25,
                            color: ColorsUtil.secondaryColorDark,
                            indent: 12,
                            endIndent: 12,
                          ),
                        ]),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 30, top: 30),
                                  child: Text(
                                    'My Details',
                                    style: TextStyle(
                                      color: ColorsUtil.primaryColorLight,
                                    ),
                                  ))
                            ]),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 49, 59, 21),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtil.primaryColorDark)),
                                      IconButton(
                                          onPressed: () async {
                                            // TODO EDIT TEXT FIELD
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: ColorsUtil.primaryColorDark,
                                          )),
                                    ],
                                  ),
                                  Text("${userData.fname} ${userData.lname}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorsUtil.textColorDark)),
                                ])),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 49, 59, 21),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Username',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtil.primaryColorDark)),
                                      IconButton(
                                          onPressed: () async {
                                            // TODO EDIT TEXT FIELD
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: ColorsUtil.primaryColorDark,
                                          )),
                                    ],
                                  ),
                                  Text(userData.username,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorsUtil.textColorDark)),
                                ])),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 49, 59, 21),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Email',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsUtil.primaryColorDark)),
                                      IconButton(
                                          onPressed: () async {
                                            // TODO EDIT TEXT FIELD
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: ColorsUtil.primaryColorDark,
                                          )),
                                    ],
                                  ),
                                  Text(currentUser.email!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorsUtil.textColorDark)),
                                ]))
                      ]);
                    } else {
                      return const Center(
                        child: Text('Error'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }
}
