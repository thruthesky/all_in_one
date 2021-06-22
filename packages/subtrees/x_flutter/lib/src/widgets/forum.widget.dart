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
///
/// 코멘트 수정은 새 창(다이얼로그)을 띄워서 한다.
/// 그 이유는 코멘트가 사진이 여러장 있어, 내용이 길게 표시되는 경우, 코멘트의 맨 꼭대기 부분(사용자 정보 등)은
/// 화면의 위로 스크롤되어 보이지 않고, 맨 아래에 있는 수정 버튼을 클릭하면
/// 코멘트 수정 창이 해당 코멘트의 맨 꼭대기 위치에 표시되어, 수정 창이 보이지 않는 것이다.
/// 그래서 수정을 하는 경우, 그냥 다이얼로그를 띄워서 수정을 한다.
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
    // c.mode = 'edit';
    // setState(() => null);
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
/// [fetch] 글 페이지를 서버로 부터 가져오면 발생되는 콜백.
class ForumWidget extends StatefulWidget {
  ForumWidget({
    Key? key,
    required this.controller,
    this.categoryId = '',
    this.titleBuilder,
    this.buttonBuilder,
    this.editBuilder,
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
  final Function? editBuilder;
  final Function? fetch;
  final Function error;
  final int limit;

  final _ForumWidgetState _state = _ForumWidgetState();
  @override
  _ForumWidgetState createState() => _state;
}

/// 게시판 위젯
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

  /// @todo 개선점. 글 작성/수정을 팝업 다이얼로그로 하는 것이 어떨까? 네비게이션이 힘들다.
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
      if (_posts.length < widget.limit) {
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
                commentContentBuilder(comment),
                commentButtonBuilder(comment),
                if (comment.mode == 'reply') ...[
                  commentEditBuilder(post, CommentModel(), parent: comment),
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

  /// 글 내용 표시 빌더
  ///
  /// 텍스트와 사진(파일)의 위치를 아래/위로 변경 할 수 있도록 하나의 빌더에서 같이 표현한다.
  contentBuilder(PostModel post) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.brown[50],
            child: Text(post.content),
          ),
          for (final f in post.files) CacheImage(f.url, width: double.infinity, height: null),
        ],
      ),
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
              child: Text('수정'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('삭제'),
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
                if (post.isComment) {
                  /// 코멘트 수정.
                  openCommentEditBuilder(post);
                } else {
                  /// 글
                  controller.showEditForm(post);
                }
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

  /// 글 작성 폼
  ///
  /// 직접 디자인하려면, 아래의 함수를 복사해서 callback builder 로 만들면 된다.
  /// 새 글 쓰기의 경우, post.idx = 0 이고, post.categoryId 에는 게시판 카테고리가 들어가 있다.
  editBuilder(PostModel post) {
    if (widget.editBuilder != null) return widget.editBuilder!(post);
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
                  ElevatedButton(onPressed: () => controller.state.edit = null, child: Text('취소')),
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
  }

  /// 코멘트 수정 시, 새창을 띄워서 수정.
  ///
  /// 새창을 띄우는 이유는 위에 설명.
  /// 기존의 코멘트 수정 창 코드를 활용한다.
  /// 코멘트 수정을 할 때, 부모 글은 필요 없다.
  /// 사진을 수정하고, 새창을 닫는다.
  Future openCommentEditBuilder(CommentModel comment) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('덧글 수정'),
                  Spacer(),
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('취소'))
                ],
              ),
              Divider(),
              commentEditBuilder(PostModel(), comment, edited: () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }

  /// 코멘트 작성 또는 수정 창
  ///
  /// [post] 부모 글. 참고로, 코멘트 수정을 하는 경우, [post] 는 빈 PostModel() 의 객체라도 상관 없다.
  /// [comment] 현재 생성되는 또는 수정되는 코멘트. 생성을 하는 경우, 빈 CommentModel() 의 객체를 만들어 전달하면 된다.
  /// [parent] 현재 코멘트의 부모 코멘트. 즉, 코멘트의 코멘트를 작성하는 경우 필요.
  commentEditBuilder(PostModel post, CommentModel comment,
      {CommentModel? parent, Function? edited}) {
    bool loading = false;
    bool focus = true;
    double progress = 0.0;

    if (comment.idx == 0) {
      // 새 코멘트 작성
      comment.rootIdx = post.idx;
      if (parent == null) {
        // 부모 글 바로 밑에 (1단계) 코멘트 작성. 즉, 부모글 내용 아래에 항상 보이는 코멘트 작성 폼.
        comment.parentIdx = post.idx;
        focus = false;
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
                  fileEditBuilder(file, comment, () => setState(() {})),
              ],
            ),
          ),
          if (progress > 0) LinearProgressIndicator(value: progress),
          Row(
            children: [
              FileUploadIcon(
                  success: (FileModel file) {
                    progress = 0;
                    setState(() => comment.files.add(file));
                  },
                  error: controller.error,
                  progress: (p) => setState(() => progress = p)),
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      autofocus: focus,
                      controller: content,
                      maxLines: null,
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
                        top: 0,
                        bottom: 0,
                        right: -2,
                        child: IconButton(
                          onPressed: () async {
                            setState(() => loading = true);
                            try {
                              comment.content = content.text;
                              await comment.edit(post);

                              /// 코멘트의 코멘트를 쓰는 경우, 코멘트 생성 후, 부모 mode='' 으로 해서, 입력 창 감추기
                              if (parent != null) parent.mode = '';
                              comment.mode = '';

                              /// 글 수정 완료 콜백
                              if (edited != null) edited();
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
          for (final f in comment.files) CacheImage(f.url, width: double.infinity, height: null),
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

  /// 파일 편집
  ///
  /// 글/코멘트 작성 폼에서, 파일을 업로드 한 후, 파일을 표시하고, 삭제 아이콘을 표시한다.
  /// 그리고 삭제 버튼이 눌러지면 삭제하고 [deleted] 콜백을 호출한다. 콜백에서는 화면 랜더링을 하면 된다.
  Widget fileEditBuilder(FileModel file, dynamic parent, Function deleted) {
    return Stack(
      children: [
        CacheImage(file.url),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () async {
              try {
                final re = await showDialog(
                    context: context, builder: (_) => confirmDialogBuilder(_, title: '삭제하시겠습니까?'));
                if (re == false) return;
                await file.delete(parent);
                deleted();
              } catch (e) {
                controller.error(e);
              }
            },
            icon: Icon(
              Icons.highlight_remove,
              color: Colors.red[700],
            ),
          ),
        ),
      ],
    );
  }

  /// 예/아니오를 선택하는 확인 창
  confirmDialogBuilder(BuildContext context, {String title = '제목'}) {
    return AlertDialog(
      title: Text(title, style: TextStyle(fontSize: 16)),
      content: Column(
        mainAxisSize: MainAxisSize.min, // 다이얼로그 크기를 딱 맞게 조절한다.
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('예'),
              ),
              SizedBox(width: 6),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('아니오'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
