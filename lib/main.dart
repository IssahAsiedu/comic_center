import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white))
      ),
      routeInformationParser: AppRoute.router.routeInformationParser,
      routeInformationProvider: AppRoute.router.routeInformationProvider,
      routerDelegate: AppRoute.router.routerDelegate,
    );
  }
}
