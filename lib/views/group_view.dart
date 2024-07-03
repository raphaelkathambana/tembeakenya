import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/views/group_detail_view.dart';

// ******************* DUMMY DATABASE ******************* //
import 'package:tembeakenya/dummy_db.dart';

// ****************************************************** //
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
  List<String> listGroup = <String>['All Groups', 'My Groups'];
  late NavigationService navigationService;
  User? user;

  String profileImageID = "defaultProfilePic";
  late int loadNum;

  final TextEditingController _search = TextEditingController();
  String search = '';

  // ****************************************************** //

  searchCard(String search, int num, bool isMember){ 
    if (search != '') {
      if (groupName[num].toLowerCase().contains(search.toLowerCase())){
        return groupMember(num, isMember);
        }    
        return const SizedBox();
    } else {
      return groupMember(num, isMember);
    }
  }

  groupMember(int num, bool isMember) {
    if (isMember == true) {
        if (member[num] == true) {
          return groupCard(num);
        } else {
        return const SizedBox();
        }
    } else {
      return groupCard(num); // If isMember is false, continue with userCard
    }
  }

  groupCard(int num) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupDetailView(userID: num)));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Color.fromARGB(0, 0, 0, 0))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorsUtil.secondaryColorDark),
            color: const Color.fromARGB(55, 99, 126, 32),
          ),
          height: 270,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
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
                    width: MediaQuery.sizeOf(context).width * .35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text(groupName[num],
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.textColorDark)),
                        ),
                        if (member[num])
                          const Text('Member',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: ColorsUtil.accentColorDark)),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
            const Divider(
              height: 2,
              color: ColorsUtil.accentColorDark,
              indent: 12,
              endIndent: 12,
            ),
            Container(
                width: MediaQuery.sizeOf(context).width * .9,
                height: 150,
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorsUtil.backgroundColorDark),
                  color: const Color.fromARGB(29, 99, 126, 32),
                ),
                child: const Text(
                    'This is where we have descriptions of the group',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: ColorsUtil.primaryColorDark))),
          ]),
        ));
    // } catch (e) {
    //   return debugPrint("Error: $e");
    // }
  }

  // ****************************************************** //

  @override
  void initState() {
    dropdownValue = listGroup.first;
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
    
      loadNum = groupName.length;
    
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
              Expanded(
                child: TextField(
                  controller: _search,
                  enableSuggestions: true,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = _search.text;
                    });
                  },
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
                  items:
                      listGroup.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
            ],
          )),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: const BoxDecoration(
            color: Color.fromARGB(0, 0, 0, 0),
          ),
          child: Column(
            children: [
              for (int i = 0; i < loadNum; i++)
                if (dropdownValue == listGroup.last) // If dropdown indicates "Friends"
                  searchCard(search, i, true)
                else if (dropdownValue == listGroup.first) // If dropdown indicates "All"
                  searchCard(search, i, false)
            ],
          )),
    ])));
  }
}
