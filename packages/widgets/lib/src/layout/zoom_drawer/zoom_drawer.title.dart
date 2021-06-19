// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:get/get.dart';

// class ZoomDrawerTitle extends StatefulWidget with PreferredSizeWidget {
//   ZoomDrawerTitle({
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
//   _ZoomDrawerTitleState createState() => _ZoomDrawerTitleState();
// }

// class _ZoomDrawerTitleState extends State<ZoomDrawerTitle> {
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
