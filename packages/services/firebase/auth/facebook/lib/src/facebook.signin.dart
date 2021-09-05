import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthFacebook {
  static Future<UserCredential> signInWithFacebook() async {
    await FacebookAuth.instance.logOut();

    // Need to logout to avoid 'User logged in as different Facebook user'
    LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.cancelled) {
      throw 'user-cancelled-facebook-sign-in';
    } else if (loginResult.status == LoginStatus.failed) {
      throw 'facebook-sign-in-failed';
    }

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<UserCredential> signIn() {
    return signInWithFacebook();
  }
}
