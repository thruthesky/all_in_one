import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  ForumController controller = ForumController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '게시판',
      back: () => controller.editing ? controller.stopEditing() : Get.back(),
      create: () => controller.create(),
      body:

          /// 게시판 위젯
          ///
          /// 글 목록, 글 읽기, 글/코멘트 작성/수정/삭제, 사진 추가/삭제, 추천 등 게시판에 대한 모든 것을 담당하는 위젯.
          /// 글 목록 가져오기, 무한 스크롤, 각종 버튼 클릭에 대한 로직은 이 위젯 내부에 들어가 있으며, 이 위젯을 통해
          /// 디자인만 변경해서 사용하면 된다.
          ///
          ///
          ///
          /// 글 위젯을 터치하면 토글 형식으로 글 내용을 보여주거나 숨긴다.
          ///
          /// [controller] - 게시판 위젯을 컨트롤.
          ///   대부분의 경우 간단하게 setState() 를 통해서 내부 상태를 관리 할 수 있지만, 때로는 코드가 복잡해 지는 경우가 있다.
          ///   예를 들면, 앱바(타이틀바)에서 글 작성 버튼 클릭시 글 작성 폼을 보여주는 겨우,
          ///     - 보여주는 것은 외부에서 상태 관리로 되지만, 글 작성 폼 내에서 취소 버튼을 누르면, 내부에서 외부의 상태를 변경해야 한다.
          ///     - 상태를 내부에 관리한다면 앱바로 부터 내부 상태까지 드릴링을 해야 한다.
          ///   이와 같은 경우, 보다 알기 쉽게, 그리고 플러터 방식으로 컨트롤러를 사용한다.
          ///
          /// [error] - 에러가 발생하면 호출되는 콜밸
          /// [fetch] - 글 목록을 가져오면 호출되는 콜백
          ForumWidget(
        controller: controller,
        categoryId: getArg('categoryId', ''),
        limit: 20,
        fetch: (List<PostModel> posts) {
          posts[0].open = true;
        },
        error: (e) => alert('앗!', e),

        /// [titleBuilder] 는 제목을 표시. 생략 가능.
        /// 제목이 클릭되면, postBuilder, commentBuilder, fileBuilder 등 글 내용을 보여주기 위한 빌더들이 실행된다.
        titleBuilder: (PostModel post) {
          Widget child;
          if (post.open) {
            /// 글 읽기 상태
            child = ListTile(
              leading: SizedBox(
                width: 48,
                height: 48,
                child: Avatar(url: post.user.photoUrl),
              ),
              title: Text('${post.idx}. ${post.title}'),
              subtitle: Text('${post.user.nicknameOrName}'),
              trailing: Icon(Icons.arrow_upward),
            );
          } else {
            /// 목록 상태
            child = ListTile(
              title: Text('${post.idx}. ${post.title}'),
              trailing: Icon(Icons.arrow_downward),
            );
          }
          return child;
        },
        // buttonBuilder: (PostModel post) {
        //   return Row(
        //     children: [
        //       TextButton(onPressed: () => post.like(), child: Text('좋아요')),
        //     ],
        //   );
        // },
      ),
    );
  }
}
