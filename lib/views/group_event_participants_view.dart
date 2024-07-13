import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tembeakenya/assets/colors.dart';
import 'package:tembeakenya/constants/routes.dart';
import 'package:tembeakenya/constants/image_operations.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/model/user.dart';
import 'package:tembeakenya/repository/get_following.dart';
import 'package:url_launcher/url_launcher.dart';

class ParticipantDetailView extends StatefulWidget {
  final dynamic currentUser;
  final dynamic selectedUser;
  const ParticipantDetailView(
      {super.key, required this.selectedUser, required this.currentUser});

  @override
  State<ParticipantDetailView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<ParticipantDetailView> {
  User? user;
  String displayUrl = '';
  late NavigationService navigationService;
  String profileImageID = '';

  // ****************************************************** //
  late String? dropdownValue;

  // late int theStepsTaken;
  // late int theDistanceWalked;
  // late int theHikes;
  late String theFullName;
  late String theUsername;
  late String thePhoneNumber;
  late String theEmail;
  late bool theFriend;
  bool isFriend = false;
  // ****************************************************** //

  textWhatsApp(thisPhoneNum) async {
    // Uri androidURL = Uri.parse('https://api.whatsapp.com/send/?phone=$thePhoneNumber&text&type=phone_number&app_absent=0');
    // Uri androidURL = Uri.parse('https://wa.me/$thePhoneNumber?text');
    Uri whatsappURL = Uri.parse('whatsapp://send/?phone=$thisPhoneNum?&text');
    if (await canLaunchUrl(whatsappURL)) {
      debugPrint(whatsappURL.toString());
      await launchUrl(whatsappURL);
    } else {
      const AlertDialog(
        content: Text('WhatsApp not Found'),
      );
    }
  }

  textSMS(thisPhoneNum) async {
    Uri smsURL = Uri.parse('sms:+$thisPhoneNum?');
    if (await canLaunchUrl(smsURL)) {
      debugPrint(smsURL.toString());
      await launchUrl(smsURL);
    } else {
      const AlertDialog(
        content: Text('Messenger not Found'),
      );
    }
  }

  email(thisEmail) async {
    Uri emailURL = Uri.parse('mailto:+$thisEmail?');
    if (await canLaunchUrl(emailURL)) {
      debugPrint(emailURL.toString());
      await launchUrl(emailURL);
    } else {
      const AlertDialog(
        content: Text('Email not Found'),
      );
    }
  }

  @override
  void initState() {
    user = widget.selectedUser;
    profileImageID = user!.image_id!;
    dropdownValue = null;

    // profileImageID = widget.selectedUser.image_id!;

    debugPrint("user: ${widget.selectedUser.fullName.toString()}");
    debugPrint("user: ${widget.selectedUser.no_of_hikes.toString()}");
    debugPrint("user: $profileImageID");
    // debugPrint(getReviews().toString());

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });

    getFriend(widget.selectedUser.id!).then((value) => {
          setState(() {
            isFriend = value;
          })
        });

    navigationService = NavigationService(router);
    super.initState();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    profileImageID = user!.image_id!;
    displayUrl = '';

    getImageUrl(profileImageID).then((String result) {
      setState(() {
        displayUrl = result;
      });
    });
    debugPrint('Ok, Image URL: $displayUrl');
  }

  @override
  Widget build(BuildContext context) {
    theFullName = user!.fullName;
    theUsername = user!.username!;
    theEmail = user!.email!;
    thePhoneNumber = '254115190303';
    // theStepsTaken = user!.no_of_steps_taken!;
    // theDistanceWalked = user!.total_distance_walked!;
    // theHikes = user!.no_of_hikes!;

    debugPrint('Ok, Image URL: $displayUrl');

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Participant Page',
            style: TextStyle(color: ColorsUtil.textColorDark),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  padding: const EdgeInsets.only(right: 3.5),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: ColorsUtil.cardColorDark,
                  ),
                  child: Column(children: [
                    const Divider(
                      height: 2,
                      color: ColorsUtil.secondaryColorDark,
                      indent: 12,
                      endIndent: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (displayUrl.isEmpty)
                              const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor:
                                          ColorsUtil.accentColorDark,
                                      child: CircleAvatar(
                                        radius: 40,
                                        child: CircularProgressIndicator(),
                                      )))
                            else
                              IconButton(
                                icon: CircleAvatar(
                                    radius: 42,
                                    backgroundColor: ColorsUtil.accentColorDark,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(displayUrl),
                                    )),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Container(
                                            padding: const EdgeInsets.all(15),
                                            child: CircleAvatar(
                                                radius:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                backgroundColor:
                                                    ColorsUtil.accentColorDark,
                                                child: CircleAvatar(
                                                  radius:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          .45,
                                                  backgroundImage:
                                                      NetworkImage(displayUrl),
                                                )),
                                          ));
                                },
                              ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * .35,
                                    child: Text(theFullName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsUtil.textColorDark)),
                                  ),
                                  Text('@$theUsername',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: ColorsUtil.accentColorDark)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        isFriend
                            ? Container(
                                margin: const EdgeInsets.only(right: 3.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorsUtil.accentColorDark),
                                height: 35,
                                width: 95,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isFriend = !isFriend;
                                      CommunityController().unFollowUser(
                                          widget.selectedUser.id!, context);
                                    });
                                  },
                                  child: const Text(
                                    'Following',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsUtil.textColorDark),
                                  ),
                                ))
                            : Container(
                                margin: const EdgeInsets.only(right: 3.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorsUtil.secondaryColorDark),
                                height: 35,
                                width: 95,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isFriend = !isFriend;
                                      CommunityController().followUser(
                                          widget.selectedUser.id!, context);
                                    });
                                  },
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsUtil.textColorDark),
                                  ),
                                ))
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: ColorsUtil.secondaryColorDark,
                      indent: 12,
                      endIndent: 12,
                    ),
                  ]),
                ),

                // Statistic has dummy writing
                Container(
                  // height: 367,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hiker\' Contact',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorsUtil.primaryColorDark)),
                        const Divider(
                          height: 15,
                          color: ColorsUtil.secondaryColorDark,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorsUtil.primaryColorDark)),
                                Row(children: [
                                  TextButton(
                                    onPressed: () {                                      
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text('Email?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      email(theEmail);
                                                      Navigator.pop(context);
                                                    }, 
                                                    child: const Text('Open Email'))
                                                ],
                                          )
                                      );
                                    },
                                    child: Text('$theEmail ',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: ColorsUtil.textColorDark)),
                                  )
                                ]),
                                const Text('Phone Number',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorsUtil.primaryColorDark)),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text('Call or Text?'),
                                              actions: [
                                                DropdownButton(
                                                    icon: const Icon(null),
                                                    value: dropdownValue,
                                                    dropdownColor: ColorsUtil
                                                        .descriptionColorDark,
                                                    underline:
                                                        Container(height: 2),
                                                    onChanged: (value) {
                                                      setState(() {});
                                                      if (value ==
                                                          'Direct call') {
                                                        FlutterPhoneDirectCaller
                                                            .callNumber(
                                                                '+$thePhoneNumber');
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    items: ['Direct call']
                                                        .map<DropdownMenuItem>(
                                                            (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    hint: const SizedBox(
                                                      child: Text('Call'),
                                                    )),
                                                DropdownButton(
                                                    icon: const Icon(null),
                                                    value: dropdownValue,
                                                    dropdownColor: ColorsUtil
                                                        .descriptionColorDark,
                                                    underline:
                                                        Container(height: 2),
                                                    onChanged: (value) {
                                                      setState(() {});
                                                      if (value == 'SMS text') {
                                                        FlutterPhoneDirectCaller
                                                            .callNumber(
                                                                '+$thePhoneNumber');
                                                      } else if (value ==
                                                          'Whatsapp text') {
                                                        textWhatsApp(thePhoneNumber);
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    items: [
                                                      'SMS text',
                                                      'Whatsapp text'
                                                    ].map<DropdownMenuItem>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    hint: const SizedBox(
                                                      child: Text('Text'),
                                                    )),
                                              ],
                                            ));
                                  },
                                  child: Text(
                                    '$thePhoneNumber ',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: ColorsUtil.textColorDark),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                ),

                // Milestone has dummy writing
                Container(
                  height: 350,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                      color: ColorsUtil.descriptionColorDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                          child: Text('Milestones',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsUtil.primaryColorDark)),
                        ),
                        const Divider(
                          height: 2,
                          color: ColorsUtil.secondaryColorDark,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .7,
                                  child: const Text(
                                      'There are no Milestones yet',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: ColorsUtil.primaryColorDark)),
                                ),
                                const Row(children: [
                                  Text(' ',
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsUtil.textColorDark)),
                                  Text(' ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: ColorsUtil.textColorDark)),
                                ])
                              ],
                            ),
                          ],
                        ),
                      ]),
                ),
              ])),
        ));
  }
}
