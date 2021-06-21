import 'package:flutter/material.dart';
import 'package:x_flutter/src/widgets/cache_image.dart';
import 'package:x_flutter/src/widgets/file_upload_icon.dart';
import 'package:x_flutter/src/widgets/spinner.dart';
import 'package:x_flutter/x_flutter.dart';

/// ForumWidget controller
///
/// ForumWidget 내부적으로 상태 관리를 하는데, 드릴링이 발생하는 경우, controller 를 통해서
/// 코드를 간편하게 한다.
/// 특히, [state] 나 [setState], [erorr] 를 통해서 간편한 코딩을 할 수 있다.
///
///
/// 글/코멘트 생성/수정을 할 때에는 [controller.showEditForm] 을 호출하면 된다.
/// 글의 경우 [ForumWidget.edit] 을 수정하여 글 생성/수정을 관리하고
/// 코멘트의 경우, 해당 코멘트의 객체를 comment.mode='edit' 와 하면 코멘트 생성/수정 폼을
/// 보여준다.
///
/// 글/코멘트 작성시 파일 업로드
///
/// 글/코멘트에서 파일 업로드를 하는 경우, 업로드된 파일을 해당 객체의 `files` 배열에 저장한다.
/// 그리고 렌더링을 할 때, 파일이 있으면 화면에 보여주고 삭제를 할 수 있게 해 주면 된다.
class ForumController {
  late _ForumWidgetState state;

  /// 글 작성(생성, 수정) 중이면 참을 리턴.
  bool get editing => state.edit != null;

  /// 글 작성을 중지한다.
  stopEditing() => state.edit = null;

  /// 글 작성
  ///
  /// 글 작성을 위한 상태를 만든다. 글 작성 폼 열기 등.
  showPostCreateForm() {
    // 현재 글 수정 상태
    if (state.edit == null) {
      // 수정 상태가 아니면, 글 작성 상태로 변경. 카테고리 지정.
      state.edit = PostModel()..categoryId = state.widget.categoryId;
    } else {
      // 수정 상태이면, 글 작성 폼 닫기
      state.edit = null;
    }
  }

  /// 새 글이 생성된 경우 호출하면 됨.
  ///
  /// 새 글을 맨 위체 추가하고, 읽기 모드로 설정.
  edited(PostModel p) {
    if (state.edit!.idx == 0) {
      // 새 글을 작성했으면, 맨 위에 추가
      state.posts.insert(0, p..open = true);
    }
    state.edit = null;
  }

  _showPostEditForm(PostModel p) {
    state.edit = p;
  }

  /// 코멘트 수정 폼을 열고, 업데이트
  _showCommentEditForm(CommentModel c) {
    c.mode = 'edit';
    setState(() => null);
  }

  /// 글 또는 코멘트 수정 폼을 열때 사용.
  showEditForm(post) {
    if (post.isComment) {
      _showCommentEditForm(post);
    } else {
      _showPostEditForm(post);
    }
  }

  /// ForumWidget 의 setState() 를 호출하여 화면을 (다시) 랜더링.
  ///
  /// 사용방법은 setState() 와 동일
  setState(VoidCallback fn) {
    fn();
    state.update();
  }

  /// 위젯에 연결된 에러 콜백을 호출한다.
  error(e) {
    state.widget.error(e);
  }
}

/// 게시판 목록 및 글 작성/수정
///
/// 여러 게시판(카테고리)가 한번에 열릴 수 있다. 그래서 질문게시판->자유게시판에서 백 버튼을 눌러 질문게시판 되돌아 갈 때,
/// 질문게시판의 기존 글(및 스크롤 상태)이 유지되어야 하므로,
/// 글 목록 및 스크롤 상태를 위젯 내부에 보관해야 한다.
///
/// [create] 이 참이면, 새 글을 작성하는 글 작성 폼 위젯을 보여준다.
class ForumWidget extends StatefulWidget {
  ForumWidget({
    Key? key,
    required this.controller,
    this.categoryId = '',
    this.titleBuilder,
    this.buttonBuilder,
    this.fetch,
    required this.error,
    this.limit = 10,
  }) : super(key: key) {
    controller.state = _state;
  }

  final ForumController controller;
  final String categoryId;
  final Function? titleBuilder;
  final Function? buttonBuilder;
  final Function? fetch;
  final Function error;
  final int limit;

  final _ForumWidgetState _state = _ForumWidgetState();
  @override
  _ForumWidgetState createState() => _state;
}

class _ForumWidgetState extends State<ForumWidget> {
  Api api = Api.instance;
  List<PostModel> posts = [];
  int page = 0;
  bool loading = false;
  bool noMorePosts = false;
  late final ForumController controller;

  final scrollController = ScrollController();

  /// 글 작성/수정 상태 관리
  ///
  /// [edit] 변수를 통해, 글 작성/수정 양식을 보여주거나 숨긴다.
  ///
  /// null 이면, 글 작성/수정이 아님.
  /// edit.idx = 0 이면, 글 작성.
  /// edit.idx != 0 이면, 글 수정.
  PostModel? _edit;
  PostModel? get edit => _edit;

  /// 글 작성 설정 변경시 setState 호출
  set edit(PostModel? p) {
    setState(() {
      _edit = p;
    });
  }

  void update() => setState(() => null);

  bool get atBottom {
    return scrollController.offset > (scrollController.position.maxScrollExtent - 240);
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    _fetchPage();
    scrollController.addListener(() {
      if (atBottom) _fetchPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (edit != null) return editBuilder(edit!);
    return ListView.separated(
      separatorBuilder: (_, i) => Divider(),
      itemBuilder: (_, i) {
        PostModel post = posts[i];
        if (post.noMorePosts) {
          return ListTile(
            title: Text('더 이상 글이 없습니다.'),
          );
        } else {
          Widget child;
          if (post.close) {
            child = titleBuilder(post);
            // child = GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: () {
            //     print('idx; ${post.idx}');
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(18.0),
            //     child: Text('${post.idx}: ${post.title}'),
            //   ),
            // );
          } else {
            child = viewBuilder(post);
          }
          // print('${post.idx}: ${post.title}');
          if (loading && i == posts.length - 1) {
            /// 글을 가져오는 중이면, 각 페이지별 맨 밑마지막 글 아래에 로더 표시
            return Column(
              children: [
                child,
                Spinner(),
              ],
            );
          } else {
            return child;
          }
        }
      },
      itemCount: posts.length,
      controller: scrollController,
    );
  }

  _fetchPage() async {
    try {
      if (loading || noMorePosts) return;
      setState(() => loading = true);
      page++;
      final _posts = await Api.instance.post.search({
        'categoryId': widget.categoryId,
        'page': page,
        'limit': widget.limit,
      });
      // posts = [...posts, ..._posts];
      _posts.forEach((PostModel p) {
        /// 각 글 별 전처리를 여기서 할 수 있음.
        /// 참고, 기본 전 처리는 PostModel 에서 되며, 여기서는 추가적인 작업을 할 수 있음.
        posts.add(p);
      });
      if (mounted) setState(() => loading = false);
      if (posts.length < widget.limit) {
        // last page
        noMorePosts = true;
        posts.add(PostModel({})..setNoMorePosts());
      }
      if (mounted) setState(() => null);
      if (widget.fetch != null) widget.fetch!(posts);
    } catch (e) {
      setState(() => loading = false);
      widget.error(e);
    }
  }

  /// 글 제목 빌더
  titleBuilder(PostModel post) {
    /// 기본 빌더
    Widget child;
    if (widget.titleBuilder == null) {
      if (post.open) {
        /// 글 읽기 상태
        child = Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(child: Icon(Icons.person)),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('${post.idx}. ${post.title}'), Text('${post.user.nicknameOrName}')],
              ),
              Spacer(),
              Icon(Icons.arrow_upward),
            ],
          ),
        );
      } else {
        /// 목록 상태
        child = Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Text('${post.idx}. ${post.title}'),
              Spacer(),
              Icon(Icons.arrow_downward),
            ],
          ),
        );
      }
    } else {
      /// 커스텀 빌더
      child = widget.titleBuilder!(post);
    }
    return GestureDetector(
      child: child,
      onTap: () {
        print('post.idx:; ${post.idx}');
        setState(() => post.open = !post.open);
      },
      behavior: HitTestBehavior.opaque,
    );
  }

  viewBuilder(PostModel post) {
    return Column(
      children: [
        titleBuilder(post),
        contentBuilder(post),
        buttonBuilder(post),
        commentEditBuilder(post, CommentModel()), // 부모 글의 코멘트 창. 항상 보여 줌.
        for (final comment in post.comments)
          Container(
            margin: EdgeInsets.only(left: commentLeftMargin(comment)),
            child: Column(
              children: [
                commentMetaBuilder(comment),
                comment.mode == 'edit'
                    ? Column(children: [Text('코멘트 수정을 합니다.'), commentEditBuilder(post, comment)])
                    : Column(children: [
                        commentContentBuilder(comment),
                        commentButtonBuilder(comment),
                      ]),
                if (comment.mode == 'reply') ...[
                  commentEditBuilder(post, CommentModel(), comment),
                ],
              ],
            ),
          )
      ],
    );
  }

  commentButtonBuilder(CommentModel comment) {
    return postAndCommentButtonBuilder(comment);
  }

  contentBuilder(PostModel post) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.white,
      child: Text(post.content),
    );
  }

  buttonBuilder(PostModel post) {
    if (widget.buttonBuilder != null) return widget.buttonBuilder!(post);
    return postAndCommentButtonBuilder(post);
  }

  /// 글과 코멘트 둘다 쓰이는 버튼 빌더
  postAndCommentButtonBuilder(dynamic post) {
    return Row(
      children: [
        if (post.isComment)
          TextButton(
            onPressed: () {
              /// 코멘트 폼 열고 닫기
              post.mode = post.mode == '' ? 'reply' : '';
              controller.setState(() {});
            },
            child: Text('댓글'),
          ),
        TextButton(
          onPressed: () => post.like().then((v) => setState(() => {})),
          child: Text('좋아요 (${post.Y})'),
        ),
        // 싫어요는 주석 처리. 싫어요 기능은 사용하지 않음.
        // TextButton(
        //   onPressed: () => post.dislike().then((v) => setState(() => {})),
        //   child: Text('싫어요 (${post.N})'),
        // ),
        // TextButton(onPressed: () => post.like(), child: Text('별쏘기')),
        // TextButton(onPressed: () => post.like(), child: Text('채팅')),
        TextButton(onPressed: () => post.like(), child: Text('신고')),
        Spacer(),
        PopupMenuButton<String>(
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert),
          ),
          initialValue: '',
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('글 수정'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('글 삭제'),
            ),
            // const PopupMenuItem<String>(
            //   value: 'profile',
            //   child: Text('프로필'),
            // ),
            // const PopupMenuItem<String>(
            //   value: 'add-friend',
            //   child: Text('친구 추가'),
            // ),
            // const PopupMenuItem<String>(
            //   value: 'block',
            //   child: Text('차단'),
            // ),
            // const PopupMenuItem<String>(
            //   value: 'report',
            //   child: Text('신고'),
            // ),
            // const PopupMenuItem<String>(
            //   value: 'posts',
            //   child: Text('글 목록'),
            // ),
            // const PopupMenuItem<String>(
            //   value: 'comments',
            //   child: Text('코멘트 목록'),
            // ),
          ],
          onSelected: (String value) async {
            try {
              if (value == 'edit') {
                /// 글/코멘트 수정 창 열기
                controller.showEditForm(post);
              }
              if (value == 'delete') {
                await post.delete();
                setState(() {});
              }
            } catch (e) {
              widget.error(e);
            }
          },
        ),
      ],
    );
  }

  /// 새 글 쓰기의 경우, post.idx = 0 이고, post.categoryId 에는 게시판 카테고리가 들어가 있다.
  editBuilder(PostModel post) {
    return Column(
      children: [
        Text('${post.categoryId}에 글 쓰기'),
        TextField(
          controller: TextEditingController()..text = post.title,
          onChanged: (v) => post.title = v,
          onSubmitted: (text) {},
          decoration: InputDecoration(
            labelText: "제목",
            hintText: "제목을 입력하세요.",
          ),
        ),
        TextField(
          controller: TextEditingController()..text = post.content,
          onChanged: (v) => post.content = v,
          onSubmitted: (text) {},
          decoration: InputDecoration(
            labelText: "내용",
            hintText: "내용을 입력하세요.",
          ),
        ),
        Row(
          children: [
            ElevatedButton(onPressed: () => edit = null, child: Text('취소')),
            ElevatedButton(
                onPressed: () =>
                    post.edit().then((p) => controller.edited(p)).catchError(widget.error),
                child: Text('글 쓰기')),
          ],
        )
      ],
    );
  }

  /// 코멘트 작성 또는 수정 창
  ///
  /// [post] 부모 글
  /// [comment] 현재 생성되는 또는 수정되는 코멘트. 생성을 하는 경우, 빈 CommentModel() 의 객체를 만들어 전달하면 된다.
  /// [parent] 현재 코멘트의 부모 코멘트. 즉, 코멘트의 코멘트를 작성하는 경우 필요.
  commentEditBuilder(PostModel post, CommentModel comment, [CommentModel? parent]) {
    bool loading = false;
    double progress = 0.0;

    if (comment.idx == 0) {
      // 새 코멘트 작성
      comment.rootIdx = post.idx;
      if (parent == null) {
        // 부모 글 바로 밑에 (1단계) 코멘트 작성
        comment.parentIdx = post.idx;
      } else {
        // 코멘트 밑에 코멘트 작성
        comment.parentIdx = parent.idx;
      }
    }
    final content = TextEditingController(text: comment.content);
    return StatefulBuilder(builder: (_, setState) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (final FileModel file in comment.files)
                  Stack(children: [
                    CacheImage(file.url),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: () => file
                                .delete(comment)
                                .then((v) => setState(() {}))
                                .catchError(controller.error),
                            icon: Icon(
                              Icons.highlight_remove,
                              color: Colors.red[700],
                            )))
                  ]),
              ],
            ),
          ),
          Row(
            children: [
              FileUploadIcon(
                  success: (FileModel file) => setState(() => comment.files.add(file)),
                  error: controller.error,
                  progress: (p) => progress = p),
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      controller: content,
                      onChanged: (v) => setState(() => null),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 40),
                        hintText: "코멘트를 입력하세요.",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          borderSide: BorderSide(
                            color: Colors.grey[800]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    if (content.text != '' || comment.files.length > 0)
                      Positioned(
                        top: -5,
                        right: -2,
                        child: IconButton(
                          onPressed: () async {
                            setState(() => loading = true);
                            try {
                              comment.content = content.text;
                              await comment.edit(post);

                              /// 코멘트의 코멘트를 쓰는 경우, 코멘트 생성 후, 부모 mode='' 으로 해서, 입력 창 감추기
                              if (parent != null) parent.mode = '';
                              controller.setState(() {});
                            } catch (e) {
                              controller.error(e);
                            }

                            setState(() => loading = false);
                          },
                          icon: loading ? Spinner() : Icon(Icons.send),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      );
    });
  }

  commentMetaBuilder(CommentModel comment) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: Colors.black54,
      child: Text(
        'Comment No. ${comment.idx}: depth: ${comment.depth}, ${comment.shortDate}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  commentContentBuilder(CommentModel comment) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: Colors.black54,
      child: Column(
        children: [
          Text(
            '${comment.content}',
            style: TextStyle(color: Colors.white),
          ),
          for (final f in comment.files)
            CacheImage(
              f.url,
              width: double.infinity,
              height: null,
            ),
        ],
      ),
    );
  }

  double commentLeftMargin(CommentModel comment) {
    switch (comment.depth) {
      case 0:
      case 1:
        return 0;
      case 2:
        return 32;
      case 3:
        return 48;
      case 4:
        return 60;
      default:
        return 68;
    }
  }
}
