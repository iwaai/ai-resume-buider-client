// import 'dart:io';

// import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImagePickerService {
//   // final ImagePicker _picker = ImagePicker();

//   /// Request permissions for camera and gallery access
//   Future<bool> _requestPermission(Permission permission) async {
//     final status = await permission.request();
//     return status.isGranted;
//   }

//   /// Pick an image from the gallery after requesting permissions
//   Future<File?> pickImageFromGallery() async {
//     // Request gallery permission
//     // bool permissionGranted = await _requestPermission(Permission.storage);
//     // bool tempPermissionGranted = await _requestPermission(Permission.photos);
//     bool permissionGranted = await _requestPermission(Permission.mediaLibrary);
//     if (!permissionGranted) {
//       debugPrint('Gallery permission denied');
//       return null;
//     }

//     // Pick image from gallery
//     // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     // return pickedFile != null ? File(pickedFile.path) : null;
//   }

//   /// Pick an image from the camera after requesting permissions
//   Future<File?> pickImageFromCamera() async {
//     // Request camera permission
//     bool permissionGranted = await _requestPermission(Permission.camera);

//     if (!permissionGranted) {
//       print('Camera permission denied');
//       return null;
//     }

//     // Pick image from camera
//     // final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     // return pickedFile != null ? File(pickedFile.path) : null;
//   }
// }
