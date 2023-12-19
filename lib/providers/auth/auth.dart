import 'package:comics_center/domain/user_data.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as p;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthNotifier extends p.Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  Future<void> googleLogin() async {
    state = AuthLoading();
    var webClientId = dotenv.env['APP_WEB_CLIENT'];

    print(webClientId);

    try {
      final googleSignIn = GoogleSignIn(clientId: webClientId);
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        state = AuthError('Error occurred whiles retrieving tokens');
        return;
      }

      final response =
          await ref.read(supabaseClientProvider).auth.signInWithIdToken(
                provider: sb.Provider.google,
                idToken: idToken,
                accessToken: accessToken,
              );

      final userData = <String, dynamic>{}
        ..addAll(response.user!.userMetadata!);

      userData['id'] = response.user!.id;
      state = AuthSuccess(UserData.fromMap(userData));

      print('done');
    } catch (e) {
      print(e);
      print('failed');
      state = const AuthError('Login Failed');
    }
  }

  void logout() async {
    var webClientId = dotenv.env['APP_WEB_CLIENT'];
    ref.read(supabaseClientProvider).auth.signOut();
    await GoogleSignIn(clientId: webClientId).signOut();
    state = const AuthInitial();
  }

  void setUser(sb.User user) {
    final userData = <String, dynamic>{}..addAll(user!.userMetadata!);
    userData['id'] = user.id;
    state = AuthSuccess(UserData.fromMap(userData));
  }
}

final authProvider =
    p.NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
