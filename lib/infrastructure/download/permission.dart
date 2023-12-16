
import 'package:permission_handler/permission_handler.dart';

class PermissionRequester {

  static Future<bool> notificationAllowed() async {
    var permissionStatus = await Permission.notification.status;

    if(permissionStatus.isDenied) {
      permissionStatus = await Permission.notification.request();
    }

    if(permissionStatus.isGranted) {
      return true;
    }

    return false;
  }

}