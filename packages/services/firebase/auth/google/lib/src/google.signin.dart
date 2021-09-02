import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthGoogleModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  FirebaseAuthGoogleModel(
      {required this.uid, required this.email, required this.displayName, required this.photoURL});
  factory FirebaseAuthGoogleModel.fromCredential(UserCredential credential) {
    if (credential.user == null)
      return FirebaseAuthGoogleModel(uid: '', email: '', displayName: '', photoURL: '');
    User user = credential.user!;
    return FirebaseAuthGoogleModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoURL: user.photoURL ?? '',
    );
  }

  toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  toMatrixLogin() {
    return {
      'firebaseUid': uid,
      'email': email,
      'nickname': displayName,
      'photoUrl': photoURL,
      'provider': 'google',
      'domain': 'app.sonub.com',
    };
  }
}

class FirebaseAuthGoogle {
  /// 구글 로그인을 하고, UserCredential 을 리턴한다.
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// 구글 로그인을 하고, Matrix 에 로그인을 하기 위해서, Map Json 데이터를 리턴한다.
  /// 리턴 예)
  /// ```json
  /// {uid: 4Xa...G3, email: thru...@gmail.com, nickname: JaeHo Song, photoUrl: https://...com/a/AA...c, provider: google, domain: app.sonub.com}
  /// ```
  static Future<Map<String, String>> signIn() async {
    UserCredential credential = await signInWithGoogle();
    return FirebaseAuthGoogleModel.fromCredential(credential).toMatrixLogin();
  }
}
