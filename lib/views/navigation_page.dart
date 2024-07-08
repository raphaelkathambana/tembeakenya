import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/routes.dart';
import '../../assets/colors.dart';
import 'package:tembeakenya/constants/timer_operation.dart';

class NavigationView extends StatefulWidget {
  final user;
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
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            color: const Color.fromARGB(135, 99, 126, 32),
            child: Column(
              children: [
                Text('Reference Time: ${lineText[0]}'),
                Text('Paused Time: ${lineText[1]}'),
                Text('Started Time: ${lineText[2]}'),
                /**************
                
                
                  Map Section
 

                **************/
              ],
            ),
          ),
          DraggableScrollableSheet(
            snap: true,
            initialChildSize: 50 / height,
            minChildSize: 50 / height,
            maxChildSize: 250 / (height * .9),
            builder: (context, scrollController) {
              return Container(
                width: width,
                decoration: BoxDecoration(
                    color: ColorsUtil.cardColorDark,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    border: Border.all(color: ColorsUtil.backgroundColorDark)),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Drag bar
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 15),
                      height: 20,
                      child: const Icon(
                        Icons.maximize_rounded,
                        color: Color.fromARGB(112, 99, 126, 32),
                        size: 60,
                      ),
                    ),

                    // Bar
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // TODO: DISTANCE
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: width * .3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${distance}m',
                                        style: const TextStyle(fontSize: 20)),
                                    const Text('Distance',
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              //  TIMER
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: width * .3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        !isStart
                                            ? '00:00:00'
                                            : !isPaused
                                                ? startDuration
                                                : paused,
                                        style: const TextStyle(fontSize: 20)),
                                    const Text('Time',
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // TODO: STEPS
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: width * .3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$steps Steps',
                                        style: const TextStyle(fontSize: 20)),
                                    const Text('Steps',
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              // TODO: SPEED
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: width * .3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${speed}m/sec',
                                        style: const TextStyle(fontSize: 20)),
                                    const Text('Speed',
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            color: ColorsUtil.descriptionColorDark,
                          ),
                          //  BUTTON
                          Container(
                            // color: ColorsUtil.cardColorDark,
                            padding: const EdgeInsets.all(10),
                            width: width * .6,
                            child: Column(
                              children: [
                                if (lineText[0] == '00:00:00')
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isStart = !isStart;
                                      });
                                      await write(
                                          '${DateTime.now()}\n00:00:00\n${DateTime.now()}');
                                      // Future.delayed(const Duration(seconds: 1));
                                    },
                                    child: const Text('Start'),
                                  )
                                else
                                  !isPaused
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            await write(
                                                '${lineText[0]}\n${DateTime.now()}\n${lineText[2]}');
                                            setState(() {
                                              paused = startDuration;
                                              isPaused = !isPaused;
                                            });
                                          },
                                          child: const Text('Pause'),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          // width: width,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await subtractTime();
                                                setState(() {
                                                  isPaused = !isPaused;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(100, 40)),
                                              child: const Text('Resume'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(100, 40)),
                                              onPressed: () async {
                                                await write(
                                                    '00:00:00\n00:00:00\n00:00:00');
                                                setState(() {
                                                  paused = '';
                                                  startDuration = '00:00:00';
                                                  isPaused = !isPaused;
                                                  isStart = false;
                                                });
                                              },
                                              child: const Text('Stop'),
                                            ),
                                          ],
                                        ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 0.5,
                          //   color: ColorsUtil.secondaryColorDark,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
