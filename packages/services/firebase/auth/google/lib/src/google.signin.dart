import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class FirebaseAuthGoogleModel {
//   final String uid;
//   final String email;
//   final String displayName;
//   final String photoURL;
//   FirebaseAuthGoogleModel(
//       {required this.uid, required this.email, required this.displayName, required this.photoURL});
//   factory FirebaseAuthGoogleModel.fromCredential(UserCredential credential) {
//     if (credential.user == null)
//       return FirebaseAuthGoogleModel(uid: '', email: '', displayName: '', photoURL: '');
//     User user = credential.user!;
//     return FirebaseAuthGoogleModel(
//       uid: user.uid,
//       email: user.email ?? '',
//       displayName: user.displayName ?? '',
//       photoURL: user.photoURL ?? '',
//     );
//   }

//   toJson() {
//     return {
//       'uid': uid,
//       'email': email,
//       'displayName': displayName,
//       'photoURL': photoURL,
//     };
//   }
// }

class FirebaseAuthGoogle {
  /// 구글 로그인을 하고, UserCredential 을 리턴한다.
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) throw 'user-cancelled-google-sign-in';

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signIn() {
    return signInWithGoogle();
  }
}
