// import 'package:all_in_one/services/globals.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:get/get.dart';
// import 'package:widgets/widgets.dart';

// class Layout extends StatelessWidget {
//   Layout({Key? key, this.title = '', required this.body}) : super(key: key);

//   final String title;
//   final Widget body;

//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawerLayout(
//       titleBar: TitleBar(title: this.title),
//       drawer: Drawer(),
//       body: body,
//     );
//   }
// }

// class TitleBar extends StatefulWidget with PreferredSizeWidget {
//   TitleBar({
//     Key? key,
//     required this.title,
//     this.titleStyle = const TextStyle(fontSize: 16),
//     this.menuTextStyle = const TextStyle(fontSize: 8),
//   }) : super(key: key);
//   final String title;
//   final TextStyle titleStyle;
//   final TextStyle menuTextStyle;
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);

//   @override
//   _TitleBarState createState() => _TitleBarState();
// }

// class _TitleBarState extends State<TitleBar> {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: navigator!.canPop()
//           ? BackButton(
//               color: Colors.black,
//               onPressed: () {
//                 Get.back();
//               })
//           : SizedBox.shrink(),
//       title: Text(widget.title, style: widget.titleStyle),
//       shape: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
//       elevation: 0,
//       backgroundColor: Colors.white,
//       actions: [
//         SizedBox(
//           width: 52,
//           child: IconButton(
//             icon: Column(
//               children: [
//                 Icon(
//                   Icons.menu,
//                   color: Colors.black,
//                 ),
//                 Text('전체메뉴', style: widget.menuTextStyle)
//               ],
//             ),
//             onPressed: () {
//               ZoomDrawer.of(context)!.toggle();
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Drawer extends StatelessWidget {
//   const Drawer({
//     Key? key,
//   }) : super(key: key);

//   move(Function fn) {
//     Get.back();
//     fn();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width * 0.58,
//       padding: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16.0),
//               color: Colors.yellow[500],
//               child: Text('사용자 아이콘, 이름, 프로필 정보'),
//             ),
//             Divider(color: Colors.grey, thickness: 1),
//             SizedBox(height: 8),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (kDebugMode)
//                       DrawerItem(
//                         iconData: Icons.developer_board,
//                         title: '개발 모드 테스트 메뉴',
//                         color: Colors.grey[100]!,
//                         onTap: () => true,
//                       ),
//                     DrawerItem(
//                       iconData: Icons.home_filled,
//                       title: '홈',
//                       color: Colors.grey[900]!,
//                       onTap: () => move(service.openHome),
//                     ),
//                     DrawerItem(
//                       iconData: Icons.info_outline,
//                       title: '어바웃 페이지',
//                       color: Colors.grey[100]!,
//                       onTap: () => move(service.openAbout),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DrawerItem extends StatelessWidget {
//   const DrawerItem({
//     Key? key,
//     required this.iconData,
//     required this.title,
//     required this.color,
//     required this.onTap,
//   }) : super(key: key);

//   final IconData iconData;
//   final String title;
//   final Color color;
//   final Function onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap(),
//       child: Container(
//         padding: EdgeInsets.all(6),
//         child: Row(
//           children: [
//             Icon(iconData, size: 25),
//             SizedBox(width: 6),
//             Expanded(
//               child: Text(title),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
