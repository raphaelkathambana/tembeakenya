
import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/routes.dart';
import '../../assets/colors.dart';

class NavigationView extends StatefulWidget {
  final user;
  const NavigationView({super.key, required this.user});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  late NavigationService navigationService;

  @override
  void initState() {
    navigationService = NavigationService(router);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Navigation Page',
            style: TextStyle(
              color: ColorsUtil.primaryColorLight,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(children: [
          Container(
            height: height,
            width: width,
            color: ColorsUtil.accentColorDark,
          ),
          
          DraggableScrollableSheet(
            snap: true,
            initialChildSize: .05,
            minChildSize: .05,
            maxChildSize: .25,
            builder: (context, scrollController) {
              return Container(
                  width: width,
                  decoration: const BoxDecoration(
                    color: ColorsUtil.backgroundColorDark,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView(controller: scrollController, children: [
                    
                    // drag bar
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 10),
                      height: 13,
                      child: const Icon(
                        Icons.maximize_rounded,
                        color: Color.fromARGB(112, 99, 126, 32),
                        size: 60,
                      ),
                    ),
                  
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: width * .3,
                                  child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Distance',
                                            style: TextStyle(fontSize: 20)),
                                        Text('Distance',
                                            style: TextStyle(fontSize: 14)),
                                      ])),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: width * .3,
                                  child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Time',
                                            style: TextStyle(fontSize: 20)),
                                        Text('Time',
                                            style: TextStyle(fontSize: 14)),
                                      ])),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: width * .3,
                                  child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Steps',
                                            style: TextStyle(fontSize: 20)),
                                        Text('Steps',
                                            style: TextStyle(fontSize: 14)),
                                      ])),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: width * .3,
                                  child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Speed',
                                            style: TextStyle(fontSize: 20)),
                                        Text('Speed',
                                            style: TextStyle(fontSize: 14)),
                                      ])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const Divider(
                      color: ColorsUtil.describtionColorDark,
                    ),
                  ]));
            },
          )
        ]));
  }
}
