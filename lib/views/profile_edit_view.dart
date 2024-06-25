import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_storage.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {

  Uint8List? pickedImage;
  late String displayUrl;
  
  String profileImageID = "defaultProfilePic";
  List<String> name = ['Beth', 'Tes'];
  String username = '@JustMeHopeless';
  String email = 'bethelhemtesfaye95@gmail.com';

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

  void pick() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      pickedImage = img;
    });
  }



  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService(router);
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorsUtil.backgroundColorDark,
            title: const Text(
              'Edit Profile Page',
              style: TextStyle(color: ColorsUtil.textColorDark),
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          Column(children: [
            if (pickedImage != null)
              Stack(children: [
                IconButton(
                    icon: CircleAvatar(
                        radius: 62,
                        backgroundColor: ColorsUtil.accentColorDark,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: MemoryImage(pickedImage!),
                        )),
                    onPressed: pick,
                ),
                const Positioned(
                  bottom: 10,
                  left: 100,
                  child: Icon(Icons.add_a_photo),
                ),
              ])
            else
              Stack(children: [
                if (displayUrl.isEmpty) 
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0x00000000),
                    child: 
                    CircleAvatar(
                    radius: 62,
                    backgroundColor: ColorsUtil.accentColorDark,
                    child: CircleAvatar(
                      radius: 60,
                      child: CircularProgressIndicator(),
                    )
                  ))                  
                  else
                  IconButton(
                    icon: CircleAvatar(
                        radius: 62,
                        backgroundColor: ColorsUtil.accentColorDark,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(displayUrl),
                        )),
                    onPressed: pick,
                  ),
                const Positioned(
                  bottom: 10,
                  left: 100,
                  child: Icon(Icons.add_a_photo),
                ),
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
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 59, 21),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Name',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Edit Name"),
                                        content: SizedBox(
                                            height: 200,
                                            width: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        "Enter your First Name",
                                                  ),
                                                  onChanged: (value) {
                                                    name[0] = value;
                                                  },
                                                ),
                                                TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        "Enter your Last Name",
                                                  ),
                                                  onChanged: (value) {
                                                    name[1] = value;
                                                  },
                                                ),
                                              ],
                                            )),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancle'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: const Text('Save'),
                                            onPressed: () =>
                                                context.push('/edit-profile'),
                                            // onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/editprofile/', (route)=>route.isFirst),
                                          ),
                                        ],
                                      ));
                              // if (name[0].trim().isNotEmpty &&
                              //     name[1].trim().isNotEmpty) {
                              //   await FirebaseFirestore.instance
                              //       .collection("Users")
                              //       .doc(currentUser.uid)
                              //       .update({
                              //     "fname": name[0],
                              //     "lname": name[1],
                              //   });
                              // } else if (name[0]
                              //     .trim()
                              //     .isNotEmpty) {
                              //   await FirebaseFirestore.instance
                              //       .collection("Users")
                              //       .doc(currentUser.uid)
                              //       .update({"fname": name[0]});
                              // } else if (name[1]
                              //     .trim()
                              //     .isNotEmpty) {
                              //   await FirebaseFirestore.instance
                              //       .collection("Users")
                              //       .doc(currentUser.uid)
                              //       .update({"lname": name[1]});
                              // }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: ColorsUtil.primaryColorDark,
                            )),
                      ],
                    ),
                    // TODO: ADD THE IF STATEMENT AND CHANGE ROUTE SETTINGS TO ADD THE BACK FUNCTIONALITY
                    // Text("${userData.fname} ${userData.lname}",
                    //     style: const TextStyle(
                    //         fontSize: 18,
                    //         color: ColorsUtil.textColorDark)),
                    Text("${name[0]} ${name[1]}",
                        style: const TextStyle(
                            fontSize: 18, color: ColorsUtil.textColorDark)),
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 59, 21),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Username',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Edit Username"),
                                        content: TextField(
                                          decoration: const InputDecoration(
                                            labelText: "Enter your Username",
                                          ),
                                          onChanged: (value) {
                                            username = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancle'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          TextButton(
                                              child: const Text('Save'),
                                              onPressed: () => context
                                                  .push('/edit-profile')),
                                        ],
                                      ));
                              // if (username.trim().isNotEmpty) {
                              //   await FirebaseFirestore.instance
                              //       .collection("Users")
                              //       .doc(currentUser.uid)
                              //       .update({
                              //     "username": username,
                              //   });
                              // }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: ColorsUtil.primaryColorDark,
                            )),
                      ],
                    ),
                    // Text(userData.username,
                    //     style: const TextStyle(
                    //         fontSize: 18,
                    //         color: ColorsUtil.textColorDark)),
                    Text(username,
                        style: const TextStyle(
                            fontSize: 18, color: ColorsUtil.textColorDark)),
                  ])),
          ElevatedButton(
              // onPressed: () => navigationService.navigateToProfile(context),
              onPressed: () {
                if (pickedImage != null) {
                  uploadPic(pickedImage!, username);
                }
                navigationService.navigateToNavbar(context);
              },
              child: const Text('Save'))
        ])
            //     } else {
            //       return const Center(
            //         child: Text('Error'),
            //       );
            //     }
            //   } else {
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   }
            // })
            ));
  }
}
