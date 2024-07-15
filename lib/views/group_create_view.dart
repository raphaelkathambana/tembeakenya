import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';

// ******************* DUMMY DATABASE ******************* //
// import 'package:tembeakenya/dummy_db.dart';

// ****************************************************** //

//      | RoleID | Role        |
//      | ------ | ----------- |
//      | 1      | Hike        |
//      | 2      | Guide       |
//      | 3      | Super Admin |

// *********** EXAMPLE DB ************ //

//      | UserID | RoleID |
//      | ------ | ------ |
//      | 1      | 1      |
//      | 1      | 2      |
//      | 2      | 1      |

//      | UserID | GoupID | RoleID |
//      | ------ | ------ | ------ |
//      | 1      | 1      | 1      |
//      | 1      | 2      | 2      |
//      | 2      | 2      | 1      |

// ****************************************************** //

class GroupCreateView extends StatefulWidget {
  final user;
  const GroupCreateView({super.key, required this.user});

  @override
  State<GroupCreateView> createState() => _GroupCreateViewState();
}

class _GroupCreateViewState extends State<GroupCreateView> {
  Uint8List? pickedImage;
  late String displayUrl;

  late int uID;

  late final TextEditingController _groupName;
  late final TextEditingController _description;

  String theGroupName = '';
  String theDescription = '';
  String profileImageID = '';
  String imageId = '';

  User? user;

  @override
  void initState() {
    user = widget.user;
    // navigationService = NavigationService(router);
    profileImageID = "defaultGroupPic";
    displayUrl = '';
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    _groupName = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  void pick() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      pickedImage = img;
    });
  }

  @override
  void dispose() {
    _groupName.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // theGroupName = groupName[uID];
    // theDescription = description[uID];

    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorsUtil.backgroundColorDark,
            title: const Text(
              'Create New Group',
              style: TextStyle(color: ColorsUtil.textColorDark),
            )),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Column(children: [
            Divider(
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
                      'Group Details',
                      style: TextStyle(
                        color: ColorsUtil.primaryColorLight,
                      ),
                    ))
              ]),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: ColorsUtil.descriptionColorDark,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Group Name',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        Icon(
                          Icons.edit,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ],
                    ),
                    SizedBox(
                      child: TextField(
                        controller: _groupName,
                        decoration: const InputDecoration(
                          hintText: "Create Group Name",
                        ),
                        onChanged: (value) {
                          // user?.username = value;
                          theGroupName = value;
                        },
                      ),
                    ),
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: ColorsUtil.descriptionColorDark,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Description',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        Icon(
                          Icons.edit,
                          color: ColorsUtil.primaryColorDark,
                        ),
                      ],
                    ),
                    SizedBox(
                      child: TextField(
                        controller: _description,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Write down a description",
                        ),
                        onChanged: (value) {
                          // user?.username = value;
                          theDescription = value;
                        },
                      ),
                    ),
                  ])),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  minimumSize: const Size(120, 50),
                  foregroundColor: ColorsUtil.textColorDark,
                  backgroundColor: ColorsUtil.secondaryColorDark,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                onPressed: () async {
                  // if (pickedImage != null) {
                  //   await uploadPic(pickedImage!, _groupName.text)
                  //       .then((value) => imageId = value);
                  // }
                  final groupName = _groupName.text;
                  final description = _description.text;
                  final guideId = user!.id;
                  CommunityController()
                      .createGroup(groupName, description, guideId!, context);
                },
                child: const Text('Create Group'),
              ))
        ])));
  }
}
