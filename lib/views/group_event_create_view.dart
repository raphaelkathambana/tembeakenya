import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/controllers/community_controller.dart';

// ******************* DUMMY DATABASE ******************* //

import 'package:tembeakenya/dummy_db.dart';
import 'package:tembeakenya/model/user.dart';

// ****************************************************** //

class GroupCreateHikeView extends StatefulWidget {
  final User user;
  final group;
  const GroupCreateHikeView(
      {super.key, required this.user, required this.group});

  @override
  State<GroupCreateHikeView> createState() => _GroupCreateHikeViewState();
}

class _GroupCreateHikeViewState extends State<GroupCreateHikeView> {
  late final TextEditingController _hikeName;
  late final TextEditingController _hikeFee;
  late final TextEditingController _description;
  late final TextEditingController _date;

  // late final List<DateTime?> _dates;

  late String? dropdownValue;

  String thehikeName = '';
  String theDescription = '';

  @override
  void initState() {
    dropdownValue = null;

    _date = TextEditingController();
    _hikeName = TextEditingController();
    _hikeFee = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _hikeName.dispose();
    _hikeFee.dispose();
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
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorsUtil.accentColorDark),
            color: ColorsUtil.cardColorDark.withOpacity(0.6),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            Text('Event Name',
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
                              hintText: "Give the Event a Name",
                            ),
                            onChanged: (value) {
                              // user?.username = value;
                              // theUsername = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                              hintText: "Give the Hike a Description",
                            ),
                            onChanged: (value) {
                              // user?.username = value;
                              // theUsername = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            Text('Hike Fee',
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
                            controller: _hikeFee,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "KSH.",
                            ),
                            onChanged: (value) {
                              // user?.username = value;
                              // theUsername = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                // width: 250,
                height: 60,
                decoration: BoxDecoration(
                    color: ColorsUtil.descriptionColorDark,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                    value: dropdownValue,
                    dropdownColor: ColorsUtil.descriptionColorDark,
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
                    hint: const SizedBox(
                      width: 195,
                      child: Text('Select Location'),
                    )),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _date,
                    decoration: const InputDecoration(
                      labelText: 'Select Date',
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
            ],
          ),
        ),
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
                              'Once you save, you can not delete a hike event'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back'),
                            ),
                            TextButton(
                              onPressed: () {
                                //save the details of the group hike
                                // TODO: location based on ID
                                // TODO: When creating an event, guide should be automatically an attendee
                                // TODO: Include hike fee
                                
                                final groupHikeName = _hikeName.text;
                                final description = _description.text;
                                // final hikeFee = _hikeFee.text;
                                // final location = dropdownValue!;
                                const location = '1';
                                final hikeDate = _date.text;

                                CommunityController().createGroupHike(
                                  groupHikeName,
                                  description,
                                  location,
                                  hikeDate,
                                  widget.group['id'],
                                  widget.user.id!,
                                  context,
                                );

                                int count = 0;
                                Navigator.of(context).popUntil((_) => count++ >= 2);
                              },
                              child: const Text('Proceed'),
                            ),
                          ],
                        ));
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
