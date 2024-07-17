import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tembeakenya/controllers/community_controller.dart';
import 'package:tembeakenya/mpesa/models/mpesa.dart';
import 'package:tembeakenya/mpesa/models/mpesaResponse.dart';
import 'package:tembeakenya/mpesa/flutter_mpesa_stk.dart';

import 'package:tembeakenya/assets/colors.dart';

class GroupEventSignUp extends StatefulWidget {
  final dynamic user;
  final dynamic groupId;
  final dynamic details;
  const GroupEventSignUp(
      {super.key,
      required this.user,
      required this.groupId,
      required this.details});

  @override
  State<GroupEventSignUp> createState() => _GroupEventSignUpState();
}

/* Sign up -> form
		- Event ID
		- User details
			- Name
			- Email
		- phone number
		- emergency contact
			- name 
			- phone number
*/

class _GroupEventSignUpState extends State<GroupEventSignUp> {
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _otherFullName;
  late final TextEditingController _otherPhone;

  late final String fullName;
  late final String email;
  late final String phone;
  late final String otherFullName;
  late final String otherEmail;
  late final String otherPhone;

  late String? dropdownValue;

  String theFullName = '';
  int thePhoneNumber = 0;

  @override
  void initState() {
    _fullName = TextEditingController(text: widget.user.fullName);
    _email = TextEditingController(text: widget.user.email);
    _phone = TextEditingController();
    _otherFullName = TextEditingController();
    _otherPhone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _otherFullName.dispose();
    _otherPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsUtil.backgroundColorDark,
          title: const Text(
            'Hike Attendance Form',
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              width: MediaQuery.sizeOf(context).width/2,
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: const Text(
                'Fill out your details',
                style: TextStyle(
                  color: ColorsUtil.primaryColorLight,
                  fontSize: 14,
                ),
              ))
        ]),
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorsUtil.accentColorDark),
            color: ColorsUtil.cardColorDark.withOpacity(0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                            Text('Full Name',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.primaryColorDark)),
                            // Icon(
                            //   Icons.edit,
                            //   color: ColorsUtil.primaryColorDark,
                            // ),
                          ],
                        ),
                        SizedBox(
                          child: TextField(
                            enabled: false,
                            controller: _fullName,
                            decoration: const InputDecoration(
                              hintText: "Please write the full name",
                            ),
                            onChanged: (value) {
                              fullName = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                            Text('Email',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsUtil.primaryColorDark)),
                            // Icon(
                            //   Icons.edit,
                            //   color: ColorsUtil.primaryColorDark,
                            // ),
                          ],
                        ),
                        SizedBox(
                          child: TextField(
                            enabled: false,
                            controller: _email,
                            decoration: const InputDecoration(
                              hintText: "Please write the email",
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                        Text('Phone Number',
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
                    // SizedBox(
                    // child:
                    // Row(
                    //   children: [
                    //     const SizedBox(
                    // width: 35,
                    //       child: Text('+254')
                    //     ),
                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.only(top: 13.5),
                              child: const Text(
                                '+254',
                                style: TextStyle(fontSize: 15.5),
                              )),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 135,
                            child: TextField(
                              controller: _phone,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              decoration: const InputDecoration(
                                hintText: "70345689",
                              ),
                              onChanged: (value) {
                                phone = "254$value";
                              },

                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              width: MediaQuery.sizeOf(context).width/1.5,
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: const Text(
                'Fill out details of your emergency contact',
                style: TextStyle(
                  color: ColorsUtil.primaryColorLight,
                  fontSize: 14,
                ),
              ))
        ]),
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorsUtil.accentColorDark),
            color: ColorsUtil.cardColorDark.withOpacity(0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                            Text('Full Name',
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
                            controller: _otherFullName,
                            decoration: const InputDecoration(
                              hintText: "Please write the full name",
                            ),
                            onChanged: (value) {
                              otherFullName = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                        Text('Phone Number',
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.only(top: 14),
                              child: const Text(
                                '+254',
                                style: TextStyle(fontSize: 15.5),
                              )),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 135,
                            child: TextField(
                              controller: _otherPhone,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              decoration: const InputDecoration(
                                hintText: "70345689",
                              ),
                              onChanged: (value) {
                                otherPhone = "254$value";
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                if (_fullName.text == '' ||
                    _otherFullName.text == '' ||
                    _email.text == '' ||
                    _phone.text.length != 9 ||
                    _otherPhone.text.length != 9) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Incomplete Form'),
                            content: const Text('Fill out all the details!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Back'),
                              ),
                            ],
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Proceed to pay?'),
                            content: Text(
                                'A prompt will be sent to pay Ksh${widget.details[7]} to +254${_phone.text}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Back'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  processSTK();
                                },
                                child: const Text('Proceed'),
                              ),
                            ],
                          ));
                }
              },
              child: const Text('Pay to Sign Up', style: TextStyle(fontSize: 14),),
            ))
      ])),
    );
  }

  processSTK() async {
    MpesaResponse response = await FlutterMpesaSTK(
            "cVWDS1b9rGjEaJpiDV4Mf1Fp4XDi8bz60vHfaEcl2moeBEm1",
            "ZlbqQAUFbAf7Hlak96VbQw9r6UFIBTqCO9xyGR97ZU0B68Mx1eQQyuSkAhcbmQRh",
            "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
            "174379",
            "https://94f9-41-90-65-205.ngrok-free.app/api/secret-url/callback",
            "default Message")
        .stkPush(Mpesa(widget.details[7], "254${_phone.text}"));
    if (response.status) {
      notify("successful stk push. please enter pin");
      showDialog (
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Confirm Payment'),
                content: const Text('Click "Confirm" after paying!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      CommunityController().signUpForGroupHike(
                          int.parse(widget.details[0].toString()),
                          int.parse(widget.user.id!.toString()),
                          _fullName.text,
                          '254${_phone.text}',
                          widget.user.email!,
                          _otherFullName.text,
                          '254${_otherPhone.text}',
                          context);
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 3);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ));
    } else {
      notify("failed. please try again");
    }
  }

  void notify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
