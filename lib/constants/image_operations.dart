
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance;

// ************ GET IMAGE URL *************** //
Future<String> getImageUrl(String picID) async {
  
  String profilePicName = "$picID.png";
  Reference? image = storageRef.ref().child("profile_images/$profilePicName");
  final url = await image.getDownloadURL();
  
  return url;
}
// ****************************************** //

// ************** PICK IMAGE **************** //
Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: source);
  
  // cropImage(image, source);
  CroppedFile? cropped = await ImageCropper().cropImage(
    sourcePath: image!.path,
    
    // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    compressQuality: 90,
    compressFormat: ImageCompressFormat.png,
  );
  Uint8List? croppedImage = await cropped?.readAsBytes();

  return croppedImage;
}
// ****************************************** //

// ************** UPLOAD IMAGE ************** //
Future<void> uploadPic(Uint8List newImage, String? username) async {
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

// ************** CROP IMAGE **************** //
Future<void> cropImage(XFile? image, ImageSource source) async {  

  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: image!.path,
    aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 16),
    compressQuality: 90,
    compressFormat: ImageCompressFormat.png,

    );
    croppedImage;
  
}

// ****************************************** //
