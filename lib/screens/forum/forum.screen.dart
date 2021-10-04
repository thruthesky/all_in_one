import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  // ForumController controller = ForumController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '게시판',
      back: () {
        /// 뒤로 가기
        ///
        /// 만약, 게시판을 열 때, 글 작성 폼을 바로 보여준 경우,
        /// 글을 작성 안 했으면, 뒤로 가기 버튼을 누르면, 이전 페이지로 간다.
        /// 글을 한번이라도 작성 했으면, 다시 작성 폼을 열면, 그 이 후 부터는 이전 페이지로 가지 않고, 작성 폼을 닫는다.
        // if (getArg('edit') == true && controller.state.editedCount == 0) Get.back();
        // return controller.editing ? controller.stopEditing() : Get.back();
      },
      create: () => () {}, // controller.togglePostEditForm(),
      body: Text('@TODO fourm wiget '),
    );
  }
}
