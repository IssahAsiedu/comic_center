import 'package:comics_center/download/permission.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static String progressChannel = "progress channel";
  static final NotificationService _notificationService =
      NotificationService._internal();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _androidInitializationSettings =
      const AndroidInitializationSettings("ic_launcher");

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  void init() async {
    final initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void createNotification(int count, int i, int id) async {
   //check permission;
    bool hasPermission = await PermissionRequester.notificationAllowed();

    if(!hasPermission) {
      return;
    }

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        progressChannel, progressChannel,
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: false,
        showProgress: true,
        maxProgress: count,
        progress: i
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.show(
        id, "progress notification", "body", platformChannelSpecifics);
  }
}
