import 'package:flutter/material.dart';
import 'package:x_flutter/src/widgets/spinner.dart';
import 'package:x_flutter/x_flutter.dart';

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

  showPostEditForm(PostModel p) {
    state.edit = p;
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

  /// 글 작성 시, 수정되는 글
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
    return ListView.builder(
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
        if (p.deleted) {
          p.title = '삭제되었습니다.';
          p.content = '삭제되었습니다.';
        } else if (p.title == '') p.title = '제목이 없습니다.';
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
    // return GestureDetector(
    //     onTap: () {
    //       print('post.idx: ${post.idx}');
    //       setState(() {
    //         post.open = !post.open;
    //       });
    //     },
    //     behavior: HitTestBehavior.opaque,
    //     child: Container(
    //         key: ValueKey('post-${post.idx}'),
    //         padding: EdgeInsets.all(16),
    //         child: Text('${post.idx}: ${post.title}')));

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
        commentFormBuilder(post),
        for (final comment in post.comments)
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.black54,
                child: Text(
                  '${comment.idx}: ${comment.content}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              commentButtonBuilder(comment),
            ],
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
        TextButton(
          onPressed: () => post.like().then((v) => setState(() => {})),
          child: Text('좋아요 (${post.Y})'),
        ),
        TextButton(
          onPressed: () => post.dislike().then((v) => setState(() => {})),
          child: Text('싫어요 (${post.N})'),
        ),
        TextButton(onPressed: () => post.like(), child: Text('별쏘기')),
        TextButton(onPressed: () => post.like(), child: Text('채팅')),
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
            const PopupMenuItem<String>(
              value: 'profile',
              child: Text('프로필'),
            ),
            const PopupMenuItem<String>(
              value: 'add-friend',
              child: Text('친구 추가'),
            ),
            const PopupMenuItem<String>(
              value: 'block',
              child: Text('차단'),
            ),
            const PopupMenuItem<String>(
              value: 'report',
              child: Text('신고'),
            ),
            const PopupMenuItem<String>(
              value: 'posts',
              child: Text('글 목록'),
            ),
            const PopupMenuItem<String>(
              value: 'comments',
              child: Text('코멘트 목록'),
            ),
          ],
          onSelected: (String value) async {
            try {
              if (value == 'edit') {
                if (post.isComment) {
                  // controller.showCommentEditForm(post);
                } else {
                  controller.showPostEditForm(post);
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

  commentFormBuilder(PostModel post) {
    CommentModel comment = CommentModel();
    comment.parentIdx = post.idx;
    comment.rootIdx = post.idx;
    return StatefulBuilder(builder: (_, setState) {
      return Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
              Expanded(
                child: Stack(
                  children: [
                    TextField(
                      onChanged: (v) => setState(() => comment.content = v),
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
                    if (comment.content != '')
                      Positioned(
                        top: -5,
                        right: -2,
                        child: IconButton(
                          onPressed: () {
                            comment.edit().then((value) => null).catchError(widget.error);
                          },
                          icon: Icon(Icons.send),
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
}
