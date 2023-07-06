import 'dart:convert';
import 'dart:io';

import 'package:comics_center/download/notification.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class Downloader extends ChangeNotifier {
  NotificationService notificationService = NotificationService();
  Map<String, int> cache = <String, int>{};

  //this function only works on android
  void downloadOnAndroid(String url) async {
    final dio = Dio();

    try {
      Directory dir = await getExternalStorageDirectory() ?? Directory('/storage/emulated/0/Download');

      List<String> parts = url.split(".");
      String extension = parts[parts.length - 1];

      String input = url + DateTime.now().toString();
      String hash = md5.convert(utf8.encode(input)).toString();
      String currentFileName = "$hash.$extension";

      String savingPath = path.join(dir.path, currentFileName);
      var id = cache.length + 1;

      dio.download(url, savingPath, onReceiveProgress: (count, total){
          var progress = ((count / total) * 100).toInt();
          notificationService.createNotification(100, progress, id);
          cache[url] = progress;
          notifyListeners();
      });

    } catch (e) {
      print("an error just occurred");
    }
  }



}
