import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tembeakenya/assets/colors.dart';

class GroupEventSignUp extends StatefulWidget {
  final user;
  const GroupEventSignUp({super.key, required this.user});

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
  late final TextEditingController _phone;

  late String? dropdownValue;

  String theFullName = '';
  int thePhoneNumber = 0;

  @override
  void initState() {
    _fullName = TextEditingController();
    _phone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
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
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                'Fill out your details',
                style: TextStyle(
                  color: ColorsUtil.primaryColorLight,
                  fontSize: 16,
                ),
              ))
        ]),
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            controller: _fullName,
                            decoration: const InputDecoration(
                              hintText: "Please write the full name",
                            ),
                            onChanged: (value) {
                              // user?.username = value;
                              // theUsername = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.only(top: 0),
                            child: const Text('+254', style: TextStyle(fontSize: 15.5),)
                          ),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 135,
                            child: TextField(
                              
                              controller: _phone,
                              decoration: const InputDecoration(
                                hintText: "70345689",
                              ),
                              onChanged: (value) {
                                // user?.username = value;
                                // theUsername = value;
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
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                'Fill out details of your emergency contact',
                style: TextStyle(
                  color: ColorsUtil.primaryColorLight,
                  fontSize: 16,
                ),
              ))
        ]),
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            controller: _fullName,
                            decoration: const InputDecoration(
                              hintText: "Please write the full name",
                            ),
                            onChanged: (value) {
                              // user?.username = value;
                              // theUsername = value;
                            },
                          ),
                        ),
                      ])),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.only(top: 0),
                            child: const Text('+254', style: TextStyle(fontSize: 15.5),)
                          ),

                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 135,
                            child: TextField(
                              
                              controller: _phone,
                              decoration: const InputDecoration(
                                hintText: "70345689",
                              ),
                              onChanged: (value) {
                                // user?.username = value;
                                // theUsername = value;
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
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Save'),
                          content: const Text(
                              'Once you save, you can not delete an Hike Event'),
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
                              },
                              child: const Text('Proceed'),
                            ),
                          ],
                        ));
              },
              child: const Text('Pay to Sign Up'),
            ))
      ])),
    );
  }
}
