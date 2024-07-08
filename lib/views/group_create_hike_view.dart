import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';

// ******************* DUMMY DATABASE ******************* //

import 'package:tembeakenya/dummy_db.dart';

// ****************************************************** //

class GroupCreateHikeView extends StatefulWidget {
  // final int userID;
  const GroupCreateHikeView({super.key});

  @override
  State<GroupCreateHikeView> createState() => _GroupCreateHikeViewState();
}

class _GroupCreateHikeViewState extends State<GroupCreateHikeView> {
  late final TextEditingController _hikeName;
  late final TextEditingController _description;
  late final TextEditingController _date;

  // late final List<DateTime?> _dates;

  late String? dropdownValue;

  String thehikeName = '';
  String theDescription = '';

  @override
  void initState() {
    dropdownValue = null;

    // int uID = widget.userID;
    _date = TextEditingController();
    _hikeName = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _hikeName.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Create a Hike Event',
            style: TextStyle(color: ColorsUtil.textColorDark),
          )),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(
          height: 25,
          color: ColorsUtil.secondaryColorDark,
          indent: 12,
          endIndent: 12,
        ),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                'Hike Details',
                style: TextStyle(
                  color: ColorsUtil.primaryColorLight,
                ),
              ))
        ]),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: ColorsUtil.describtionColorDark,
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
                  controller: _hikeName,
                  decoration: const InputDecoration(
                    hintText: "Give the Hike a name",
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
                color: ColorsUtil.describtionColorDark,
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
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          // width: 250,
          height: 60,
          decoration: BoxDecoration(
              color: ColorsUtil.describtionColorDark,
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton(
            value: dropdownValue,
            dropdownColor: ColorsUtil.describtionColorDark,
            underline: Container(height: 2),
            onChanged: (value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: locations.map<DropdownMenuItem>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: 
              const SizedBox(
                width: 195,
                child: Text('Select Location'),
              )
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: 250,
            height: 60,
            decoration: BoxDecoration(
                color: ColorsUtil.describtionColorDark,
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: _date,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _date.text = pickedDate.toString().split(" ")[0];
                  });
                }
              },
            )),
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
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Save'),
                          content: const Text(
                              'Once you save, you can not delete an Hike Event'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Proceed'),
                            ),
                          ],
                        ));

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
              child: const Text('Create'),
            ))
      ])),
    );
  }
}

/*
  Create a Hike Event
    - will have a dropdown of all hikes that exists (retrieved from db)
    	- Name of the Hike (input)
    	- group ID (automatic, retreaved from db)
    	- location ID (from dropdown)
    	- group admin ID (automatic, retreaved from db)
    	- date (need a date picker)
    	- save button
*/