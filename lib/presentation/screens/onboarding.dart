import 'package:comics_center/presentation/widgets/button/google_button.dart';
import 'package:comics_center/presentation/widgets/dialog/error_dialog.dart';
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
        Navigator.of(context).push(ErrorDialog(message: next.message));
      }

      if (next is AuthSuccess) {
        context.pushReplacement(AppRouteNotifier.home);
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
          child: ColoredBox(color: Colors.black45),
        ),

        //content
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                //google in button
                GoogleButton(
                  onTap: () {
                    ref.read(authProvider.notifier).googleLogin();
                  },
                ),
                const SizedBox(height: 20),

                //or section
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
                const SizedBox(height: 20),

                //dive in button
                InkWell(
                  onTap: () {
                    context.pushReplacement(AppRouteNotifier.home);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Dive right in >>',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
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
