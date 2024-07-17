import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
// import 'package:tembeakenya/dummy_db_3.dart';
import 'package:tembeakenya/views/home_location_view.dart';
import 'package:tembeakenya/assets/colors.dart';
// import 'package:tembeakenya/model/user_model.dart';

class HomeView extends StatefulWidget {
  final User user;
  final dynamic locations;
  const HomeView({super.key, required this.locations, required this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<String> displayUrl;
  // late List<User> reviews;
  // late String? dropdownValue;
  List<String> groupFilter = <String>['All Groups', 'My Groups'];
  late NavigationService navigationService;
  User? user;

  String profileImageID = "";
  late int loadNum;

  final TextEditingController _search = TextEditingController();
  String search = '';

  searchCard(String search, int num) {
    if (search != '') {
      if (widget.locations[num][1].toLowerCase().contains(search.toLowerCase())) {
        return locationCard(num);
      }
      return const SizedBox();
    } else {
      return locationCard(num);
    }
  }

  locationCard(int num) {
    dynamic name = widget.locations[num][1];
    dynamic waypoints = widget.locations[num][2];
    dynamic distance = widget.locations[num][3];
    dynamic duration = widget.locations[num][4];

    return TextButton(
        onPressed: () async {
          
          dynamic reviews;

          await CommunityController().getReviews().then(
            (review) {
              setState(() {
                reviews = review;
              });
            },
          );

          if (!mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeLocationView(
                        user: user,
                        location: widget.locations[num],
                        reviews: reviews,
                      )));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorsUtil.secondaryColorDark),
            color: ColorsUtil.cardColorDark,
          ),
          // height: 400,
          padding: const EdgeInsets.all(5),
          // margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
          child: Column(children: [
            if (displayUrl[num].isEmpty)
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
                width: MediaQuery.sizeOf(context).width * .9,
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: ColorsUtil.backgroundColorDark),
                    // color: Colors.amber,
                    image: DecorationImage(
                      image: NetworkImage(displayUrl[num]),
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
                width: MediaQuery.sizeOf(context).width * .9,
                // height: 130,
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorsUtil.backgroundColorDark),
                  color: ColorsUtil.descriptionColorDark,
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: ColorsUtil.textColorDark)),
                    Text('Distance: ${distance}m',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: ColorsUtil.primaryColorDark)),
                    Text('Estimated Duration: $duration',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: ColorsUtil.primaryColorDark)),
                  ],
                )),
          ]),
        ));
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    String profileImageID = '';

    loadNum = widget.locations.length;
    displayUrl = List<String>.filled(loadNum, '');

    for (int i = 0; i < loadNum; i++) {
      profileImageID = widget.locations[i][5];
      getImageUrl(profileImageID).then((String result) {
        setState(() {
          displayUrl[i] = result;
        });
      });
    }
  }
  // ****************************************************** //

  @override
  void initState() {
    navigationService = NavigationService(router);

    loadNum = widget.locations.length;
    displayUrl = List<String>.filled(loadNum, '');

    for (int i = 0; i < loadNum; i++) {
      profileImageID = widget.locations[i][5];
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
          title: const Text(
            'Home Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                const Divider(
                  height: 2,
                  color: ColorsUtil.secondaryColorDark,
                  indent: 12,
                  endIndent: 12,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * .90,
                  margin: const EdgeInsets.only(top: 20, bottom: 25),
                  height: 50,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: ColorsUtil.cardColorDark,
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
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < loadNum; i++) searchCard(search, i)
                      ],
                    )),
              ])),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigationService.navigateToTest(context);
          },
          child: const Icon(Icons.add),
        ));
  }
}
