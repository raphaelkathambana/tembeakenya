import 'package:flutter/material.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import '../../assets/colors.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  late List list;
  @override
  void initState() {
    super.initState();
    CommunityController().getHikes().then((value) {
      setState(() {
        list = value;
      });
    });
    // list = getReviewData();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: ColorsUtil.secondaryColorLight,
      foregroundColor: ColorsUtil.textColorLight,
      minimumSize: const Size(279, 59),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/mountbackground.png'),
                fit: BoxFit.fitWidth)),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // CommunityController().getReviews().then((value) {
                    //   setState(() {
                    //     list = value;
                    //   });
                    // });
                  },
                  style: raisedButtonStyle,
                  child: const Text('click me'),
                ),
                Text(list[1][1].toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
