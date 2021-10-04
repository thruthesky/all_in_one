// import 'package:flutter/material.dart';
// import 'package:widgets/widgets.dart';
// import 'package:x_flutter/x_flutter.dart';

// /// 회원 가입 양식
// ///
// /// 회원 가입에 성공하면 [success] 콜백이 호출된다. 콜백 인자로 사용자 모델이 전달된다.
// class UserRegisterForm extends StatelessWidget {
//   UserRegisterForm({Key? key, required this.success, required this.error}) : super(key: key);

//   final Function success;
//   final Function error;
//   final email = TextEditingController();
//   final password = TextEditingController();
//   final name = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: email,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(labelText: '로그인 이메일', hintText: '이메일 주소를 입력해주세요.'),
//         ),
//         spaceMd,
//         TextField(
//           controller: password,
//           decoration: InputDecoration(labelText: '로그인 비밀번호', hintText: '비밀번호를 입력해주세요.'),
//         ),
//         spaceMd,
//         TextField(
//           controller: name,
//           decoration: InputDecoration(labelText: '사용자 이름', hintText: '사용자 이름을 입력해주세요.'),
//         ),
//         spaceMd,
//         Row(
//           children: [
//             Spacer(),
//             TextButton(
//                 onPressed: () async {
//                   try {
//                     final user = await UserApi.instance.register({
//                       'email': email.text,
//                       'password': password.text,
//                       'name': name.text,
//                     });
//                     success(user);
//                   } catch (e) {
//                     error(e);
//                   }
//                 },
//                 child: Text('회원 가입')),
//           ],
//         )
//       ],
//     );
//   }
// }
