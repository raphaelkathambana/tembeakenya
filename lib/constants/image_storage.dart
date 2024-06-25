
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance;

// ************ GET IMAGE URL *************** //
Future<String> getImageUrl(picID) async {
  
  String profilePicName = "$picID.png";
  Reference? image = storageRef.ref().child("profile_images/$profilePicName");
  final url = await image.getDownloadURL();
  
  return url;
}
// ****************************************** //

// ************** PICK IMAGE **************** //
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}
// ****************************************** //

// ************** UPLOAD IMAGE ************** //
Future<void> uploadPic(newImage, username) async {

  /*
    Since we don't have a database that changes image ID from 
    "defaultProfilePic" to "${username}ProfilePic" all images
    shall be saved as "defaultProfilePic", thus 
      String imageID = "defaultProfilePic";
    instead of 
      String imageID = "${username}ProfilePic";
  */
  
  String imageID = "defaultProfilePic";

  // String imageID = "${username}ProfilePic";
  
  Reference reference = storageRef.ref().child("profile_images/$imageID.png");
  reference.putData(newImage);
}
// ****************************************** //

