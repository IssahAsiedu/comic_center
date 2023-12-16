import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MarvelRestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var publicKey = dotenv.env['PUBLIC_KEY'];
    var privateKey = dotenv.env['PRIVATE_KEY'];
    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    var inputForHash = timeStamp + privateKey! + publicKey!;
    var hash = md5.convert(utf8.encode(inputForHash)).toString();

    options.queryParameters.putIfAbsent("ts", () => timeStamp);
    options.queryParameters.putIfAbsent("apikey", () => publicKey);
    options.queryParameters.putIfAbsent("hash", () => hash);
    handler.next(options);
  }
}
