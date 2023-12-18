import 'package:comics_center/presentation/shared/button/google_button.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    ref.listen(authProvider, (previous, next) {
      if (next is AuthError) {
        print('error');
      }

      if (next is AuthSuccess) {
        print('success');
      }
    });

    return Stack(
      children: [
        //background
        Positioned.fill(
          child: Image.asset(
            AppAssets.onboardingImage,
            fit: BoxFit.fill,
          ),
        ),

        //cover
        const Positioned.fill(
          child: ColoredBox(
            color: Colors.black45,
          ),
        ),

        //content
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontFamily: 'Bangers',
                    fontSize: 35,
                  ),
                ),
                const SizedBox(
                  width: 250,
                  child: Text(
                    'Navigate your way through marvel\'s collection',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                GoogleButton(
                  onTap: () {
                    ref.read(authProvider.notifier).googleLogin();
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          'OR',
                          style: TextStyle(
                            fontFamily: 'Bangers',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          color: Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  child: TextButton(
                    onPressed: () {
                      GoRouter.of(context).pushReplacement(AppRoute.home);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: const Text(
                      'Dive right in >>',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.2)
              ],
            ),
          ),
        )
      ],
    );
  }
}
