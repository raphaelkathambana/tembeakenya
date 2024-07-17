import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/views/nav_page.dart';
// import 'package:tembeakenya/views/test.dart';
import '../../assets/colors.dart';
import 'package:tembeakenya/constants/timer_operation.dart';

class NavigationView extends StatefulWidget {
  final dynamic user;
  const NavigationView({super.key, required this.user});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  late NavigationService navigationService;

  bool isStart = false;
  bool isPaused = false;

  String paused = '';

  String startDuration = '00:00:00';
  String pauseDuration = '00:00:00';

  int distance = 0;
  int steps = 0;
  int speed = 0;

  @override
  void initState() {
    navigationService = NavigationService(router);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// *************** TIMER RELATED ****************//
    if (lineText.isNotEmpty) {
      read().then(
        (String result) {
          setState(() {
            text = result;
            lineText = const LineSplitter().convert(result);
          });
        },
      );
    } else {
      lineText = ['00:00:00', '00:00:00', '00:00:00'];
      read().then(
        (String result) {
          setState(() {
            text = result;
            lineText = const LineSplitter().convert(result);
          });
        },
      );
    }

    if (lineText[0] != '00:00:00') {
      isStart = true;
      startDuration = startCountUp(lineText[0]);
      if (lineText[1] != '00:00:00') {
        pauseCountUp(lineText[1]);
      }
    }
// **********************************************//

    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: height,
              width: width,
              color: const Color.fromARGB(135, 99, 126, 32),
              child: const NavigationPageView()
              // Column(
              // children: [
              //   Text('Reference Time: ${lineText[0]}'),
              //   Text('Paused Time: ${lineText[1]}'),
              //   Text('Started Time: ${lineText[2]}'),
              //   // TextButton(onPressed: () {
              //   //   Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //       builder: (context) => const TestApp()
              //   //   ));
              //   // }, child: const Text('Test'),)
              //   /**************

              //     Map Section

              //   **************/
              // ],
              // ),
              ),
        ],
      ),
    );
  }
}
