import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
// import 'package:tembeakenya/controllers/auth_controller.dart';
import 'package:tembeakenya/model/user.dart';

class GroupView extends StatefulWidget {
  final dynamic currentUser;
  const GroupView({super.key, required user, this.currentUser});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  // ****************************************************** //

  late String displayUrl;
  late String? dropdownValue;
  List<String> list = <String>['All', 'Friend'];
  late NavigationService navigationService;
  User? user;

  String profileImageID = "defaultProfilePic";

  // ****************************************************** //

  // ******************* DUMMY DATABASE ******************* //
  List<String> fullName = [
    'Raphael Kathambana',
    'Blen Tesfaye',
    'Bitania Tesfaye'
  ];
  List<String> username = ['HikeLover_69', 'blenn.08', 'Bitu_Pichu'];
  List<bool> friend = [true, false, false];

  // ****************************************************** //

  userCard(int num) {
    return Card(
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
            if (displayUrl.isEmpty)
              const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0x00000000),
                  child: CircleAvatar(
                      radius: 37,
                      backgroundColor: ColorsUtil.accentColorDark,
                      child: CircleAvatar(
                        radius: 35,
                        child: CircularProgressIndicator(),
                      )))
            else
              CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0x00000000),
                  child: CircleAvatar(
                      radius: 37,
                      backgroundColor: ColorsUtil.accentColorDark,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(displayUrl),
                      ))),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .47,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Text(fullName[num],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorsUtil.textColorDark)),
                  ),
                  Text('@${username[num]}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ColorsUtil.accentColorDark)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  friend[num] = !friend[num];
                });
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(95, 35),
                  foregroundColor: ColorsUtil.textColorDark,
                  backgroundColor: friend[num]
                      ? ColorsUtil.accentColorDark
                      : ColorsUtil.secondaryColorDark),
              child: friend[num] ? const Text('Friends') : const Text('Add'),
            )
          ],
        ),
        const Divider(
          height: 2,
          color: ColorsUtil.secondaryColorDark,
          indent: 12,
          endIndent: 12,
        ),
      ]),
    );

    // }
  }

  // ****************************************************** //

  @override
  void initState() {
    dropdownValue = list.first;
    displayUrl = '';
    navigationService = NavigationService(router);
    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // user = widget.currentUser;
    debugPrint('Ok, Image URL: $displayUrl');

    // NavigationService navigationService = NavigationService(router);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Container(
          width: MediaQuery.sizeOf(context).width * .90,
          margin: const EdgeInsets.only(top: 20, bottom: 25),
          height: 50,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(55, 99, 126, 32),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  // controller: _password,
                  enableSuggestions: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  style: const TextStyle(fontSize: 14),
                  underline: Container(height: 2),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
            ],
          )),
      const Divider(
        height: 2,
        color: ColorsUtil.secondaryColorDark,
        indent: 12,
        endIndent: 12,
      ),
      Column(
        children: [
          for (int i = 0; i <= 2; i++)
            if (dropdownValue == list.last && friend[i] == true)
              userCard(i)
            else if (dropdownValue == list.first)
              userCard(i),
        ],
      ),
    ])));
  }
}
