import 'package:comics_center/firebase_options.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppInitializationScreen extends StatefulWidget {
  const AppInitializationScreen({super.key});

  @override
  State<AppInitializationScreen> createState() =>
      _AppInitializationScreenState();
}

class _AppInitializationScreenState extends State<AppInitializationScreen> {
  bool encounteredError = false;

  bool firebaseInitialized = false;
  bool supabaseInitialized = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //loader
          if (!encounteredError)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 39,
                  backgroundColor: Colors.redAccent,
                  child: Lottie.asset(AppAssets.drStrangeLottieFile),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Getting things ready..',
                  style: TextStyle(
                    fontFamily: 'Bangers',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )
              ],
            )

          //error
          else
            Column(
              children: [
                const Text('Ann error ocurred.'),

                //spacer
                const SizedBox(height: 20),

                InkWell(
                  onTap: () => _init(),
                  child: const Text(
                    'REFRESH',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Future<void> _init() async {
    try {
      setState(() => encounteredError = false);
      if (!firebaseInitialized) {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
        firebaseInitialized = true;
      }

      var supabaseAppUrl = dotenv.env['SUPABASE_APP_URL'];
      var supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (!supabaseInitialized) {
        await Supabase.initialize(
          url: supabaseAppUrl!,
          anonKey: supabaseAnonKey!,
        );
        supabaseInitialized = true;
      }

      if (!(supabaseInitialized && firebaseInitialized)) return;

      if (mounted) {
        context.pushReplacement(AppRouteNotifier.onboarding);
      }
    } catch (e) {
      setState(() => encounteredError = true);
    }
  }
}
