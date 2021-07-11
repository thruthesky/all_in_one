// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

// class ZoomDrawerLayout extends StatefulWidget {
//   ZoomDrawerLayout(
//       {Key? key,
//       required this.titleBar,
//       required this.drawer,
//       required this.body,
//       this.backgroundColor = Colors.blue})
//       : super(key: key);

//   final PreferredSizeWidget titleBar;
//   final Widget drawer;
//   final Widget body;
//   final Color backgroundColor;

//   @override
//   _ZoomDrawerLayoutState createState() => _ZoomDrawerLayoutState();
// }

// class _ZoomDrawerLayoutState extends State<ZoomDrawerLayout> {
//   late final ZoomDrawerController drawerController;

//   @override
//   void initState() {
//     super.initState();
//     drawerController = ZoomDrawerController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawer(
//       controller: drawerController,
//       style: DrawerStyle.Style1,
//       showShadow: true,
//       angle: 0,
//       backgroundColor: Colors.grey[300]!,
//       slideWidth: MediaQuery.of(context).size.width * .6,
//       menuScreen:
//           Scaffold(backgroundColor: widget.backgroundColor, body: SafeArea(child: widget.drawer)),
//       mainScreen: Stack(
//         children: [
//           Scaffold(
//             backgroundColor: Colors.white,
//             appBar: widget.titleBar,
//             body: Column(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         child: widget.body, // 스크린 화면
//                         onPanUpdate: (details) {
//                           // Drawer 메뉴 오픈을 6 픽셀 이상하면,
//                           if (details.delta.dx > 6 && drawerController.isOpen!() == false) {
//                             drawerController.open!();
//                           } else if (details.delta.dx < 6 && drawerController.isOpen!()) {
//                             drawerController.close!();
//                           }
//                         },
//                       ),
//                       // @todo 게시판의 경우, 글 쓰기 버튼 표시
//                       // FloatingButton(widget.forum),
//                     ],
//                   ),
//                 ),
//                 // SafeArea(child: BottomMenus()),
//               ],
//             ),
//           ),
//           // 검색 버튼이 눌러지면, 검색 레이어를 뛰울 것.
//           // SearchLayer(),
//         ],
//       ),
//       borderRadius: 24.0,
//     );
//   }
// }
