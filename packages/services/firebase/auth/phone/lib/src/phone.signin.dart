import 'package:firebase_auth/firebase_auth.dart';

/// 전화번호 로그인
///
/// 설정 및 설명은 공식문서 참고: https://firebase.flutter.dev/docs/auth/phone
class FirebaseAuthPhone {
  /// 전화번호 확인을 한다.
  ///
  /// PhoneAuthCredential 이 전화번호 로그인 완료 후 얻게 되는 객체이다.
  ///
  static verifyPhoneNumber({
    required String phoneNumber,
    required Function verificationCompleted,
    required Function verificationFailed,
    required Function codeSent,
    required Function codeAutoRetrievalTimeout,
  }) async {
    print('    ==> verifyPhoneNumber; number; $phoneNumber');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        /// Android 에서만 자동으로 SMS code 를 입력 콜백.
        /// Android 에서 자동 SMS code resolution 을 지원하는 장치만 해당한다. 모든 Anroid 폰이 다 되는 것은 아니다.
        /// 이 기능이 지원되면, 사용자는 SMS code 를 직접 입력 할 필요없이 자동으로 입력되어 확인이 완료된다.
        /// 만약, 이 기능이 지원되면, [PhoneAuthCredential] 을 사용하여 로그인이나 전화번호 확인 끝났다는 표시를 할 수 있다.

        print('verificationCompleted(); credential');
        print(credential);
        verificationCompleted(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        /// 실패 콜백.
        /// 전화번호 잘못된 오류 또는 SMS quota 초과 등.
        /// e.code 에는 invalid-phone-number 와 같은 값이 들어간다.
        /// 사용자에게 e.message (e.code) 와 같이 보여주면 된다.
        print('verificationFailed(); erorr; ${e.code} - ${e.message}');
        verificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        /// Firebase 에서 사용자에게 SMS code 를 보낸 경우 콜백.
        /// resendToken 은 오직 Android 에서만 지원한다. iOS 에는 항상 null 이다. 통일된 코딩을 하기 위해서 resendToken 을 사용하지 않는다.
        ///
        /// Android 에서 자동 SMS code 입력을 지원하지 않는다면, 이 함수가 호출되고, SMS code 가 사용자에게 전달된다.
        /// 사용자는 전달 받은 SMS code 를 입력해야하는데, 바로 이 콜백 함수에서 그 입력 박스를 띄워주는 것이다.
        /// 사용자가 받은 SMS code 와 verification ID 를 가지고 PhoneAuthProvider.credential() 함수를 호출하면,
        /// PhoneAuthCredential 을 받을 수 있다.
        ///
        /// 만약, SMS code 가 잘못되어 올바른 PhoneAuthCredential 을 얻지 못했다면, 처음 부터 새로 할 수 있는 옵션을 두어야 한다.
        ///
        /// 코드 참고: 공식문서: https://firebase.flutter.dev/docs/auth/phone#codesent
        print('codeSent(); verificationId; $verificationId');
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        /// 타임아웃 콜백.
        /// 사용자가 SMS code 를 시간 제한 내에 입력하지 못한 경우.
        /// 특히, Android 에서 자동 SMS code 입력 기능이 지원되는 경우, 장치가 특정 시간내에 SMS message 를 받지 못한 경우, 이 콜백이 호출된다.
        ///
        /// 이 콜백 함수가 호출되면, 이 후 부터는 더 이상 SMS message 를 기다리지 않는다.
        /// 즉, 해당 SMS message 가 늦게 도착해도, 이 콜백 함수가 호출되었으면, 그 SMS message 의 code 는 쓸 수 없는 것이다.
        /// 그래서, 이 콜백 함수가 호출되면, 처음 부터 새로 시작하도록 해야 한다.
        ///
        /// 주의, Emulator 에서 테스트 번호와 테스트 SMS code 로 테스트 할 때, 성공/실패와 상관없이 항상 이 콜백 함수가 호출 되었다.
        print('codeAutoRetrievalTimeout()');
        codeAutoRetrievalTimeout(verificationId);
      },
    );
  }
}
