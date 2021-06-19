import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(getArg('categoryId'));
    return Layout(
        title: '게시판',
        body: Container(
          child:

              /// 게시판 위젯
              ///
              /// 글 목록, 글 읽기, 글/코멘트 작성/수정/삭제, 사진 추가/삭제, 추천 등 게시판에 대한 모든 것을 담당하는 위젯.
              /// 글 목록 가져오기, 무한 스크롤, 각종 버튼 클릭에 대한 로직은 이 위젯 내부에 들어가 있으며, 이 위젯을 통해
              /// 디자인만 변경해서 사용하면 된다.
              ///
              /// 글 위젯을 터치하면 토글 형식으로 글 내용을 보여주거나 숨긴다.
              ///
              /// [error] - 에러가 발생하면 호출되는 콕밸
              /// [fetch] - 글 목록을 가져오면 호출되는 콜백
              ForumWidget(
                  categoryId: getArg('categoryId'),
                  limit: 20,
                  fetch: (List<PostModel> posts) {
                    posts[0].open = true;
                  },
                  error: (e) => alert('앗!', e),

                  /// [titleBuilder] 는 제목을 표시. 생략 가능.
                  /// 제목이 클릭되면, postBuilder, commentBuilder, fileBuilder 등 글 내용을 보여주기 위한 빌더들이 실행된다.
                  titleBuilder: (PostModel post) {
                    Widget child;

                    /// 기본 빌더
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
                  buttonBuilder: (PostModel post) {
                    return Row(
                      children: [
                        TextButton(onPressed: () => post.like(), child: Text('좋아요')),
                      ],
                    );
                  }),
        ));
  }
}
