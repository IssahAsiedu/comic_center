import 'package:comics_center/download/notification.dart';
import 'package:dio/dio.dart';

class Downloader {

  void download(String url, int index) {
    NotificationService notificationService = NotificationService();

    final dio = Dio();

    try {
      dio.download(url, '/storage/emulated/0/Download/skfjewoin', onReceiveProgress: (count, total){
          notificationService.createNotification(100, ((count / total) * 100).toInt(), 1);
      });

    } catch (e) {
      print("an error just occurred");
    }
  }


}
