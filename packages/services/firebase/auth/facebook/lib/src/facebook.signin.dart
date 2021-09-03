import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthFacebook {
  static Future<UserCredential> signInWithFacebook() async {
    await FacebookAuth.instance.logOut();

    // Need to logout to avoid 'User logged in as different Facebook user'
    LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  /// 애플 로그인을 하고, Matrix 에 로그인을 하기 위해서, Map Json 데이터를 리턴한다.
  /// 리턴 예)
  /// ```json
  /// {uid: 4Xa...G3, email: thru...@gmail.com, nickname: JaeHo Song, photoUrl: https://...com/a/AA...c, provider: google, domain: app.sonub.com}
  /// ```
  static Future<Map<String, String>> signIn() async {
    UserCredential credential = await signInWithFacebook();
    User user = credential.user!;

    return {
      'firebaseUid': user.uid,
      'email': user.email ?? '',
      'nickname': user.displayName ?? '',
      'photoUrl': user.photoURL ?? '',
      'provider': 'facebook',
      'domain': 'app.sonub.com',
    };
  }
}
