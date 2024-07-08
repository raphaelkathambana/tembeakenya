import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';

// ******************* DUMMY DATABASE ******************* //
import 'package:tembeakenya/dummy_db.dart';

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

class GroupEditView extends StatefulWidget {
  final int userID;
  const GroupEditView({super.key, required this.userID});

  @override
  State<GroupEditView> createState() => _GroupEditViewState();
}

class _GroupEditViewState extends State<GroupEditView> {
  Uint8List? pickedImage;
  late String displayUrl;

  late int uID;

  late final TextEditingController _groupName;
  late final TextEditingController _description;

  String theGroupName = '';
  String theDescription = '';
  String profileImageID = '';

  @override
  void initState() {
    // user = widget.currentUser;
    // navigationService = NavigationService(router);
    // profileImageID = "${user!.image_id}";
    profileImageID = "defaultGroupPic";
    displayUrl = '';
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    int uID = widget.userID;
    _groupName = TextEditingController(text: groupName[uID]);
    _description = TextEditingController(text: description[uID]);
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
    int uID = widget.userID;

    theGroupName = groupName[uID];
    theDescription = description[uID];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Edit Group',
            style: TextStyle(color: ColorsUtil.textColorDark),
          )),
      body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
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
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                        radius: 62,
                        backgroundColor: ColorsUtil.accentColorDark,
                        child: CircleAvatar(
                          radius: 60,
                          child: CircularProgressIndicator(),
                        )))
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
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    hintText: "Edit Group Name",
                  ),
                  onChanged: (value) {
                    // user?.username = value;
                    // theUsername = value;
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  decoration: const InputDecoration(
                    hintText: "Write down a description",
                  ),
                  onChanged: (value) {
                    // user?.username = value;
                    // theUsername = value;
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
                //   if (pickedImage != null) {
                //     await uploadPic(
                //             pickedImage!,
                //             _username.text.isNotEmpty
                //                 ? _username.text
                //                 : user!.username)
                //         .then((value) => imageId = value);
                //   }
                //   final firstname = _firstname.text.isNotEmpty
                //       ? _firstname.text
                //       : user!.firstName;
                //   final lastname = _lastname.text.isNotEmpty
                //       ? _lastname.text
                //       : user!.lastName;
                //   final username = _username.text.isNotEmpty
                //       ? _username.text
                //       : user!.username;
                //   final email =
                //       _email.text.isNotEmpty ? _email.text : user!.email;
                //   final profileImageId =
                //       imageId.isNotEmpty ? imageId : user!.image_id.toString();
                //   if (!context.mounted) return;
                //   AuthController(navigationService).updateProfileInformation(
                //       username!,
                //       email!,
                //       firstname!,
                //       lastname!,
                //       profileImageId,
                //       context);
                // int count = 0;
                // Navigator.of(context).popUntil((_) => count++ >= 2);
              },
              child: const Text('Update'),
            ))
      ])),
    );
  }
}
