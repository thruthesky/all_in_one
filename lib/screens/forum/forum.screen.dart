import 'package:all_in_one/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utils/utils.dart';
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
      back: () {
        /// 뒤로 가기
        ///
        /// 만약, 게시판을 열 때, 글 작성 폼을 바로 보여준 경우,
        /// 글을 작성 안 했으면, 뒤로 가기 버튼을 누르면, 이전 페이지로 간다.
        /// 글을 한번이라도 작성 했으면, 다시 작성 폼을 열면, 그 이 후 부터는 이전 페이지로 가지 않고, 작성 폼을 닫는다.
        if (getArg('edit') == true && controller.state.editedCount == 0) Get.back();
        return controller.editing ? controller.stopEditing() : Get.back();
      },
      create: () => controller.togglePostCreateForm(),
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
        showEditFormOnInit: getArg('edit', false),
        controller: controller,
        categoryId: getArg('categoryId', ''),
        limit: 20,
        fetch: (List<PostModel> posts) {
          // 첫번째 글 열기. 아래와 같이 `open` 에 true 를 주면 된다.
          // posts[0].open = true;
        },
        error: (e) => alert('앗!', e),
        separatorBuilder: () => spaceXxs,
        closedTitleBuilder: (PostModel post) {
          return Container(
            padding: EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Row(children: [
              Text('${post.title}'),
              Spacer(),
              Icon(Icons.arrow_downward),
            ]),
          );
        },
        editBuilder: (PostModel post) {
          bool loading = false;
          double progress = 0.0;

          /// 자체적 state 관리. 즉, 글 작성 폼에서는 외부 상태와 상관없이 독자적으로 상태를 관리한다.
          return StatefulBuilder(
            builder: (_, setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.categoryId} 게시판 글 쓰기',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextField(
                      controller: TextEditingController()..text = post.title,
                      onChanged: (v) => post.title = v,
                      onSubmitted: (text) {},
                      decoration: InputDecoration(
                        labelText: "제목",
                        hintText: "제목을 입력하세요.",
                      ),
                    ),
                    spaceXl,
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: TextField(
                        controller: TextEditingController()..text = post.content,
                        onChanged: (v) => post.content = v,
                        onSubmitted: (text) {},
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: "내용",
                          hintText: "내용을 입력하세요.",
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        FileUploadIcon(
                            success: (FileModel file) {
                              progress = 0;
                              setState(() => post.files.add(file));
                            },
                            error: controller.error,
                            progress: (p) => setState(() => progress = p)),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () => controller.state.edit = null, child: Text('취소')),
                        SizedBox(width: 6),
                        ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    try {
                                      setState(() => loading = true);
                                      final p = await post.edit();

                                      /// 글 쓰기 완료 후, 이 콜백을 실행하면, 글 목록으로 돌아 감.
                                      controller.edited(p);
                                    } catch (e) {
                                      controller.error(e);
                                    }
                                    setState(() => loading = false);
                                  },
                            child: loading ? Spinner() : Text('글 쓰기')),
                      ],
                    ),

                    /// 사진 업로드 전송률(바 그래프) 표시
                    if (progress > 0) LinearProgressIndicator(value: progress),

                    /// 업로드 된 사진 표시
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          for (final FileModel file in post.files)
                            controller.state.fileEditBuilder(file, post, () => setState(() {})),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
