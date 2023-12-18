import 'package:comics_center/presentation/shared/button/google_button.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

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
                    'Navigate your way through mavel\'s collection',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 40),
                GoogleButton(
                  onTap: () {},
                ),
                Align(
                  child: TextButton(
                    onPressed: () {
                      GoRouter.of(context).pushReplacement(AppRoute.home);
                    },
                    child: const Text(
                      'Dive right in >>',
                      style: TextStyle(fontSize: 18),
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
