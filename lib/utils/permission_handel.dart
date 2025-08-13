import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> checkAndRequestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
