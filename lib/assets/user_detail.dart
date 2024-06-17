import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserDetail {
  
  final String? id;
  final String username;
  final String fname;
  final String lname;

  const UserDetail({
    this.id,
    required this.username,
    required this.fname,
    required this.lname,
  });

  toJson() {
    return {
      "username": username,
      "fname": fname,
      "lname": lname,
    };
  }

  factory UserDetail.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserDetail(
      id: document.id,
      username: data["username"], 
      fname: data["fname"], 
      lname: data["lname"],
      );
  }

  static Future<UserDetail> getCurrentUser(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    final userData = snapshot.docs.map((e) => UserDetail.fromSnapshot(e)).single;
    return userData;
  }
}