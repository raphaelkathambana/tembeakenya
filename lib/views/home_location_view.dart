import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/dummy_db_3.dart';
import 'package:tembeakenya/assets/colors.dart';
// import 'package:tembeakenya/model/user_model.dart';

class HomeLocationView extends StatefulWidget {
  final dynamic user;
  const HomeLocationView({
    super.key,
    required this.user,
  });

  @override
  State<HomeLocationView> createState() => _HomeLocationViewState();
}
// Pic
// name
// distance and duration
// reviews
// button to nav ?????
//

class _HomeLocationViewState extends State<HomeLocationView> {
  late List<String> displayUrl;
  // late String? dropdownValue;
  List<String> groupFilter = <String>['All Groups', 'My Groups'];
  late NavigationService navigationService;
  User? user;

  String profileImageID = "defaultProfilePic";
  late int loadNum;

  @override
  void initState() {
    navigationService = NavigationService(router);

    loadNum = location.length;
    displayUrl = List<String>.filled(loadNum, '');

    for (int i = 0; i < loadNum; i++) {
      profileImageID = locationImage[i];
      getImageUrl(profileImageID).then((String result) {
        setState(() {
          displayUrl[i] = result;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.backgroundColorDark,
        title: const Text(
          'Location Page',
          style: TextStyle(color: ColorsUtil.textColorDark),
        ),
      ),
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: ColorsUtil.secondaryColorDark),
              color: ColorsUtil.cardColorDark,
            ),
            // height: 360,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Column(children: [
              if (displayUrl[0].isEmpty)
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width * .9,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorsUtil.backgroundColorDark),
                      // color: Colors.amber,
                      image: DecorationImage(
                        image: NetworkImage(displayUrl[0]),
                        fit: BoxFit.cover,
                      )),
                ),
              const Divider(
                height: 2,
                color: ColorsUtil.accentColorDark,
                indent: 12,
                endIndent: 12,
              ),
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 110,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                    color: ColorsUtil.descriptionColorDark,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((location[0]),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.textColorDark)),
                      Text((locationDesc[0]),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: ColorsUtil.primaryColorDark)),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorsUtil.descriptionColorDark,
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Distance',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: ColorsUtil.primaryColorDark)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                Text("0",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.textColorDark)),
                                Text(' m',
                                    style: TextStyle(
                                        height: 2,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.textColorDark)),
                              ]),
                              Text('Duration',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: ColorsUtil.primaryColorDark)),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                Text("2",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.textColorDark)),
                                Text(' h',
                                    style: TextStyle(
                                        height: 2,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.textColorDark)),
                                Text(" 30",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.textColorDark)),
                                Text(' m',
                                    style: TextStyle(
                                        height: 2,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: ColorsUtil.textColorDark)),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
            ]),
          )),
    );
  }
}
