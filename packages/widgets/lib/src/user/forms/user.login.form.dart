// import 'package:flutter/material.dart';
// import 'package:widgets/widgets.dart';
// import 'package:x_flutter/x_flutter.dart';

// class UserLoginForm extends StatelessWidget {
//   UserLoginForm({
//     Key? key,
//     required this.success,
//     required this.error,
//     required this.register,
//   }) : super(key: key);

//   final Function success;
//   final Function error;
//   final VoidCallback register;
//   final email = TextEditingController();
//   final password = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: email,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(labelText: '로그인 이메일', hintText: '이메일 주소를 입력해 주세요.'),
//         ),
//         spaceLg,
//         TextField(
//           controller: password,
//           decoration: InputDecoration(labelText: '로그인 비밀번호', hintText: '비밀번호를 입력해 주세요.'),
//         ),
//         spaceMd,
//         Row(
//           children: [
//             TextButton(
//               onPressed: () async {
//                 try {
//                   final user = await UserApi.instance
//                       .login({'email': email.text, 'password': password.text});
//                   success(user);
//                   // service.openHome();
//                 } catch (e) {
//                   error(e);
//                   // service.error(e);
//                 }
//               },
//               child: Text('회원 로그인'),
//             ),
//             Spacer(),
//             TextButton(onPressed: register, child: Text('회원 가입'))
//           ],
//         )
//       ],
//     );
//   }
// }
