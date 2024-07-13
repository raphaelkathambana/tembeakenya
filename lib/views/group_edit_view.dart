import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';

// ******************* DUMMY DATABASE ******************* //
// import 'package:tembeakenya/dummy_db.dart';

class GroupEditView extends StatefulWidget {
  final group;
  final user;
  const GroupEditView({super.key, required this.group, required this.user});

  @override
  State<GroupEditView> createState() => _GroupEditViewState();
}

class _GroupEditViewState extends State<GroupEditView> {
  Uint8List? pickedImage;
  late String displayUrl;

  late final TextEditingController _groupName;
  late final TextEditingController _description;

  late int theGroupID;

  String imageId = '';
  String theGroupName = '';
  String theDescription = '';

  String profileImageID = '';

  @override
  void initState() {
    _groupName = TextEditingController(text: widget.group['name']);
    _description = TextEditingController(text: widget.group['description']);
    debugPrint(widget.user.id.toString());
    displayUrl = '';
    profileImageID = widget.group['image_id'];
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

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
    theGroupID = widget.group['id'];
    theGroupName = widget.group['name'];
    theDescription = widget.group['description'];

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
                    widget.group['name'] = value;
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
                    // group?.description = value;
                    widget.group['description'] = value;
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
                if (pickedImage != null) {
                  await uploadPic(pickedImage!, theGroupID.toString())
                      .then((value) => imageId = value);
                }
                final groupName = _groupName.text.isNotEmpty
                    ? _groupName.text
                    : widget.group['name'];
                final description = _description.text.isNotEmpty
                    ? _description.text
                    : widget.group['description'];
                final profileImageId =
                    imageId.isNotEmpty ? imageId : widget.group['image_id'];

                if (!context.mounted) return;
                CommunityController().updateGroupDetails(
                    widget.group['id'],
                    widget.user.id,
                    groupName,
                    description,
                    profileImageId,
                    context);
              },
              child: const Text('Update'),
            ))
      ])),
    );
  }
}
