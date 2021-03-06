// import 'package:flutter/material.dart';
// import 'package:wordpress/widgets/cache_image.dart';
// import 'package:wordpress/widgets/post.file_upload_icon.dart';
// import 'package:wordpress/wordpress.dart';

// /// PostList controller
// ///
// /// This is to manage the state of PostList.
// /// You may use it whenever you need to do drilling to pass some variable or action over the widget tree.
// /// You can do [setState], chaging states or calling methods.
// ///
// /// PostList 내부적으로 상태 관리를 하는데, 드릴링이 발생하는 경우, controller 를 통해서
// /// 코드를 간편하게 한다.
// /// 특히, [state] 나 [setState], [erorr] 를 통해서 간편한 코딩을 할 수 있다.
// ///
// ///
// /// 글/코멘트 생성/수정을 할 때에는 [controller.showEditForm] 을 호출하면 된다.
// /// 글의 경우 [PostList.edit] 을 수정하여 글 생성/수정을 관리하고
// /// 코멘트의 경우, 해당 코멘트의 객체를 comment.mode='edit' 와 하면 코멘트 생성/수정 폼을
// /// 보여준다.
// ///
// /// 글/코멘트 작성시 파일 업로드
// ///
// /// 글/코멘트에서 파일 업로드를 하는 경우, 업로드된 파일을 해당 객체의 `files` 배열에 저장한다.
// /// 그리고 렌더링을 할 때, 파일이 있으면 화면에 보여주고 삭제를 할 수 있게 해 주면 된다.
// ///
// /// 코멘트 수정은 새 창(다이얼로그)을 띄워서 한다.
// /// 그 이유는 코멘트가 사진이 여러장 있어, 내용이 길게 표시되는 경우, 코멘트의 맨 꼭대기 부분(사용자 정보 등)은
// /// 화면의 위로 스크롤되어 보이지 않고, 맨 아래에 있는 수정 버튼을 클릭하면
// /// 코멘트 수정 창이 해당 코멘트의 맨 꼭대기 위치에 표시되어, 수정 창이 보이지 않는 것이다.
// /// 그래서 수정을 하는 경우, 그냥 다이얼로그를 띄워서 수정을 한다.
// ///
// /// ! 주의, PostList 이 먼저 랜더링된 후, controller 를 사용해야 한다. PostList 이 랜더링되지 않았는데,
// /// ! controller.togglePostEditForm() 등을 사용한다면, 얘기치 않은 동작을 할 수 있다.
// ///
// /// @example
// /// ```ts
// /// controller.setState(() {});
// /// ```
// class PostListController {
//   late _PostListState state;

//   /// 글 작성(생성, 수정) 중이면 참을 리턴.
//   bool get editing => state.edit != null;

//   /// 글 작성을 중지한다.
//   stopEditing() => state.edit = null;

//   /// 글 작성
//   ///
//   /// 글 작성을 위한 상태를 만든다. 글 작성 폼 열기 등.
//   togglePostEditForm() {
//     // 현재 글 수정 상태
//     if (state.edit == null) {
//       // 수정 상태가 아니면, 글 작성 상태로 변경. 카테고리 지정.
//       state.edit = WPPost.fromJson({'slug': state.slug});
//     } else {
//       // 수정 상태이면, 글 작성 폼 닫기
//       state.edit = null;
//     }
//   }

//   /// 새 글이 생성된 경우 호출하면 됨.
//   ///
//   /// 참고, 새 글을 작성한 후 반드시 이 함수를 호출 해야 함. (코멘트는 아님)
//   ///
//   /// 새 글을 맨 위체 추가하고, 읽기 모드로 설정.
//   edited(WPPost p) {
//     if (state.edit!.id == 0) {
//       // 새 글을 작성했으면, 맨 위에 추가
//       state.posts.insert(0, p..open = true);
//     } else {
//       // 글 수정이면, 현재 위치에 변경.
//       int i = state.posts.indexWhere((element) => element.id == p.id);
//       state.posts[i] = p;
//       // What if category changed? Should the app list previous category or new category?
//     }

//     if (state.widget.edited != null) {
//       state.widget.edited!(p);
//     }
//     state.editedCount++;
//     state.edit = null;
//   }

//   ///
//   showPostEditForm(WPPost p) {
//     state.edit = p;
//   }

//   /// 코멘트 수정 폼을 열고, 업데이트
//   // _showCommentEditForm(WPComment c) {
//   // c.mode = 'edit';
//   // setState(() => null);
//   // }

//   /// 글 또는 코멘트 수정 폼을 열때 사용.
//   // @Deprecated('Use showPostEditForm')
//   // showEditForm(post) {
//   //   if (post.isComment) {
//   //     _showCommentEditForm(post);
//   //   } else {
//   //     _showPostEditForm(post);
//   //   }
//   // }

//   /// PostList 의 setState() 를 호출하여 화면을 (다시) 랜더링.
//   ///
//   /// 사용방법은 setState() 와 동일
//   setState(VoidCallback fn) {
//     fn();
//     state.update();
//   }

//   /// 위젯에 연결된 에러 콜백을 호출한다.
//   error(e) {
//     state.widget.error(e);
//   }
// }

// typedef WidgetBuilder = Widget Function();
// typedef WidgetWidgetIndexBuilder = Widget Function(Widget, int);
// typedef PostWidgetBuilder = Widget Function(WPPost post);
// typedef ForumButtonBuilder = Widget Function(dynamic entity);
// typedef CommentWidgetBuilder = Widget Function(WPComment comment);
// typedef CommentViewWidgetBuilder = Widget Function(WPPost post, WPComment comment);
// typedef FileEditBuilder = Widget Function(WPFile file, dynamic parent, Function deleted);
// typedef FilesDisplayBuilder = Widget Function(List<WPFile> files);
// typedef CommentEditBuilder = Widget Function(
//     WPPost post, WPComment comment, WPComment? parent, Function? edited);

// /// 게시판 목록 및 글 작성/수정
// ///
// /// 여러 게시판(카테고리)가 한번에 열릴 수 있다. 그래서 질문게시판->자유게시판에서 백 버튼을 눌러 질문게시판 되돌아 갈 때,
// /// 질문게시판의 기존 글(및 스크롤 상태)이 유지되어야 하므로,
// /// 글 목록 및 스크롤 상태를 위젯 내부에 보관해야 한다.
// ///
// /// [separatorBuilder] 는 각 글 사이에 구분자이다.
// ///
// /// [fetch] 글 페이지를 서버로 부터 가져오면 발생되는 콜백.
// ///
// /// [showEditFormOnInit] 이 true 이면, 게시판 글 쓰기 페이지를 먼저 연다.
// ///
// /// 글을 쓸 때, 사용자가 카테고리 변경을 할 수 있다.
// ///   카테고리를 [editableCategories] 에 지정하고
// ///   적절하게 표현(디자인)을 하여 사용자가 카테고리 변경을 할 수 이께 해 주면 된다.
// ///   빠져 있는 카테고리는 기본적으로 선택을 해 주도록 한다.
// ///   예를 들어 qna, discussion 이 지정되었는데, job 카테고리에서 글 쓰기를 하면,
// ///   기본적으로 job 이 선택되게 해 준다. 하지만, label 이 지정되지 않았으므로, label 이
// ///   categoryId 로 되기 때문에, 보기 좋지 않다. 그래서 가능한 모든 카테고리를
// ///   [editableCategories] 에 넣어 주는 것이 좋다.
// ///
// /// 글(코멘트 아님)을 생성 또는 수정하면 [edited] 콜백이 호출된다.
// /// 글이 생성 또는 수정된 회 수를 [editedCount] 에 저장한다.
// ///
// /// [postIdxOnTop] 에 글 번호(또는 SEO URL, path)를 입력하면 해당 글을 먼저 로드하여 읽기 모드로 표시하고, 그 글의
// ///   카테고리의 글들을 목록한다.
// /// [postOnTop] 에는 WPPost 값을 지정 할 수 있는데, 이렇게하면 글을 서버로 부터 가져오지 않고
// ///   곧 바로 그 글의 카테고리를 목록한다.
// ///
// /// [closedTitleBuilder], [openedTitleBuilder], [viewBuilder] are for displaying posts on the list.
// /// [decoratePostWidget] is the widget builder for displaying a post on the list.
// /// It takes a widget that comes from one of [closedTitleBuilder], [openedTitleBuilder], [viewBuilder].
// /// You can use this builder to re-design(or customize) the look of the post on the list.
// /// One example of this builder is to display a menu on top of list. See the example below.
// /// ```dart
// /// decoratePostWidget: (Widget child, int i) => Column( children: [if (i == 0) Text('Forum top'), child],),
// /// ```
// class PostList extends StatefulWidget {
//   PostList({
//     Key? key,
//     required this.controller,
//     this.slug,
//     this.editableCategories,
//     this.userId,
//     this.searchKey,
//     this.noMorePostBuilder,
//     this.deletedTitleBuilder,
//     this.loaderBuilder,
//     this.viewBuilder,
//     this.listBuilder,
//     this.decoratePostWidget,
//     this.contentBuilder,
//     this.closedTitleBuilder,
//     this.openedTitleBuilder,
//     this.commentMetaBuilder,
//     this.commentContentBuilder,
//     this.commentEditBuilder,
//     this.commentViewBuilder,
//     this.confirmDialogBuilder,
//     this.fileEditBuilder,
//     this.buttonBuilder,
//     this.editBuilder,
//     this.separatorBuilder,
//     this.postIdxOnTop,
//     this.postOnTop,
//     this.fetch,
//     required this.error,
//     this.edited,
//     this.postsPerPage = 10,
//     this.showEditFormOnInit = false,
//   }) : super(key: key) {
//     controller.state = _state;
//   }

//   final PostListController controller;
//   final String? slug;
//   final Map<String, String>? editableCategories;
//   final int? userId;
//   final WidgetBuilder? noMorePostBuilder;
//   final WidgetBuilder? deletedTitleBuilder;
//   final WidgetBuilder? loaderBuilder;
//   final WidgetWidgetIndexBuilder? decoratePostWidget;
//   final WidgetBuilder? listBuilder;
//   final PostWidgetBuilder? viewBuilder;
//   final PostWidgetBuilder? contentBuilder;
//   final PostWidgetBuilder? closedTitleBuilder;
//   final PostWidgetBuilder? openedTitleBuilder;
//   final PostWidgetBuilder? editBuilder;
//   final CommentWidgetBuilder? commentMetaBuilder;
//   final CommentWidgetBuilder? commentContentBuilder;
//   final CommentViewWidgetBuilder? commentViewBuilder;
//   final CommentEditBuilder? commentEditBuilder;
//   final WidgetBuilder? confirmDialogBuilder;
//   final ForumButtonBuilder? buttonBuilder;
//   final FileEditBuilder? fileEditBuilder;
//   final WidgetBuilder? separatorBuilder;
//   final Function? fetch;
//   final Function? edited;
//   final dynamic postIdxOnTop;
//   final WPPost? postOnTop;
//   final Function error;
//   final int postsPerPage;
//   final String? searchKey;
//   final bool showEditFormOnInit;

//   final _PostListState _state = _PostListState();
//   @override
//   _PostListState createState() => _state;
// }

// /// 게시판 위젯
// class _PostListState extends State<PostList> {
//   WordpressApi api = WordpressApi.instance;
//   List<WPPost> posts = [];
//   int page = 0;
//   int editedCount = 0;
//   bool loading = false;
//   bool noMorePosts = false;
//   late final PostListController controller;

//   final scrollController = ScrollController();

//   String slug = '';

//   /// 글 작성/수정 상태 관리
//   ///
//   /// [edit] 변수를 통해, 글 작성/수정 양식을 보여주거나 숨긴다.
//   /// [edit] 이 null 이면, 글 작성/수정이 아님.
//   /// [edit] 은 WPPost 의 값을 가지는데,
//   ///   - edit.idx = 0 이면, 글 작성.
//   ///   - edit.idx != 0 이면, 글 수정.
//   /// PostList 이 초기화 될 때, [showEditFormOnInit] 이 true 의 값을 가진다면,
//   /// [togglePostEditForm]을 호출 해서, 글 작성 폼을 보여준다.
//   /// 이 때, [slug] 값을 이용해서, 그 카테고리에 글을 작성한다.
//   /// 만약, 글 작성 폼을 보여줄 때, 수정할 글이나 [slug] 값이 없다면,
//   ///   [editableCategories] 에 지정된 카테고리를 사용자가 선택 할 수 있도록 한다.
//   WPPost? _edit;
//   WPPost? get edit => _edit;

//   /// 글 작성 설정 변경시 setState 호출
//   set edit(WPPost? p) {
//     setState(() {
//       _edit = p;
//     });
//   }

//   void update() => setState(() => null);

//   bool get atBottom {
//     return scrollController.offset > (scrollController.position.maxScrollExtent - 240);
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = widget.controller;
//     if (widget.showEditFormOnInit) {
//       controller.togglePostEditForm();
//     }

//     /// If `widget.postIdxOnTop` is not null, we fetch it first, then fetch for the list with the fetched post's categoryId.
//     else if (widget.postIdxOnTop != null) {
//       _fetchPostOnTop(widget.postIdxOnTop!);
//     } else if (widget.postOnTop != null) {
//       _setPostViewAndFetchPage(widget.postOnTop!);
//     } else {
//       slug = widget.slug!;
//       _fetchPage();
//     }
//     scrollController.addListener(() {
//       if (atBottom) {
//         _fetchPage();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (edit != null) return editBuilder(edit!);
//     return listBuilder();

//     // return SingleChildScrollView(
//     //   child: Column(
//     //     children: [
//     //       if (widget.topBuilder != null) widget.topBuilder!(),
//     //       Expanded(child: listBuilder()),
//     //     ],
//     //   ),
//     // );
//   }

//   Widget listBuilder() {
//     if (widget.listBuilder != null) return widget.listBuilder!();

//     /// Loader
//     /// Show loader for the first time on forum listing.
//     /// This won't be displayed if there is a post opened on top.
//     if (posts.length == 0 && loading && page == 1) {
//       if (widget.loaderBuilder != null) return widget.loaderBuilder!();
//     }

//     if (page == 1 && posts.length < 1) {
//       return Center(child: Text('No posts yet.'));
//     }

//     return ListView.separated(
//       separatorBuilder: (_, i) =>
//           widget.separatorBuilder == null ? Divider() : widget.separatorBuilder!(),
//       itemBuilder: (_, i) {
//         WPPost post = posts[i];

//         if (post.noMorePosts) {
//           return noMorePostBuilder();
//         } else {
//           Widget postWidget;

//           if (post.deleted) {
//             postWidget = widget.deletedTitleBuilder != null
//                 ? widget.deletedTitleBuilder!()
//                 : Text('deleted');
//           } else if (post.close) {
//             postWidget = closedTitleBuilder(post);
//           } else {
//             postWidget = viewBuilder(post);
//           }

//           /// Loader
//           /// This will be shown on the first page loading if a post is open on the top.
//           if (loading && i == posts.length - 1) {
//             /// 글을 가져오는 중이면, 각 페이지별 맨 밑마지막 글 아래에 로더 표시
//             postWidget = Column(
//               children: [
//                 postWidget,
//                 if (widget.loaderBuilder != null) widget.loaderBuilder!(),
//               ],
//             );
//           }

//           /// Decorate the post widget.
//           if (widget.decoratePostWidget != null) {
//             return widget.decoratePostWidget!(postWidget, i);
//           }
//           return postWidget;
//         }
//       },
//       itemCount: posts.length,
//       controller: scrollController,
//     );
//   }

//   Widget noMorePostBuilder() {
//     if (widget.noMorePostBuilder != null) return widget.noMorePostBuilder!();

//     return ListTile(title: Text('No more posts'));
//   }

//   _fetchPage() async {
//     try {
//       if (loading || noMorePosts) return;
//       setState(() => loading = true);
//       page++;
//       final _posts = await PostApi.instance.posts(
//         searchKeyword: widget.searchKey,
//         author: widget.userId,
//         slug: slug,
//         page: page,
//         postsPerPage: widget.postsPerPage,
//       );
//       // posts = [...posts, ..._posts];
//       _posts.forEach((WPPost p) {
//         /// Hide if the post is shown on the top.
//         if (widget.postIdxOnTop != null) {
//           if (widget.postIdxOnTop is int && widget.postIdxOnTop == p.id) return;
//         } else if (widget.postOnTop != null && widget.postOnTop!.id == p.id) {
//           return;
//         } else {
//           /// 각 글 별 전처리를 여기서 할 수 있음.
//           /// 참고, 기본 전 처리는 WPPost 에서 되며, 여기서는 추가적인 작업을 할 수 있음.
//           posts.add(p);
//         }
//       });
//       if (mounted) setState(() => loading = false);
//       if (_posts.length < widget.postsPerPage) {
//         /// Add an empty post at the end when there is no more post.
//         /// It may be the last post or last page.
//         /// By adding empty post with `noMorePosts` at the end, the app can display no more posts on ui.
//         noMorePosts = true;
//         posts.add(WPPost.empty()..setNoMorePosts());
//       }
//       if (mounted) setState(() => null);
//       if (widget.fetch != null) widget.fetch!(posts);
//     } catch (e) {
//       setState(() => loading = false);
//       widget.error(e);
//     }
//   }

//   /// View (Display details) of a post
//   /// Get post to display on top, then posts of the category (of the post).
//   _fetchPostOnTop(int id) async {
//     try {
//       final post = await PostApi.instance.get(id);
//       _setPostViewAndFetchPage(post);
//     } catch (e) {
//       widget.error(e);
//     }
//   }

//   /// Sets the top post in view mode.
//   ///   Or land forum list screen with a post in view mode on top.
//   _setPostViewAndFetchPage(WPPost post) {
//     // posts.insert(0, post);
//     post.open = true;
//     slug = post.slug;
//     posts.add(post);
//     _fetchPage();
//   }

//   /// 글이 닫힌 경우, 제목 빌더
//   Widget closedTitleBuilder(WPPost post) {
//     Widget child;
//     if (widget.closedTitleBuilder == null) {
//       /// 기본 디자인
//       child = Container(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Text('${post.title}'),
//             Spacer(),
//             Icon(Icons.arrow_downward),
//           ],
//         ),
//       );
//     } else {
//       /// 커스텀 빌더
//       child = widget.closedTitleBuilder!(post);
//     }
//     return GestureDetector(
//       child: child,
//       onTap: () {
//         print('open post.idx:; ${post.id}');
//         setState(() => post.open = true);
//       },
//       behavior: HitTestBehavior.opaque,
//     );
//   }

//   Widget openedTitleBuilder(WPPost post) {
//     /// 기본 빌더
//     Widget child;
//     if (widget.openedTitleBuilder == null) {
//       child = Container(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(child: Icon(Icons.person)),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [Text('${post.id}. ${post.title}'), Text('${post.authorName}')]),
//             ),
//             SizedBox(width: 16),
//             Icon(Icons.arrow_upward),
//           ],
//         ),
//       );
//     } else {
//       /// 커스텀 빌더
//       child = widget.openedTitleBuilder!(post);
//     }
//     return GestureDetector(
//       child: child,
//       onTap: () {
//         print('close post.idx:; ${post.id}');
//         setState(() => post.open = false);
//       },
//       behavior: HitTestBehavior.opaque,
//     );
//   }

//   /// Display post view widget(s) for reading the post.
//   ///
//   /// When user tap on closed title widget, [post.opened] becomes true and this callback method will be called.
//   Widget viewBuilder(WPPost post) {
//     if (widget.viewBuilder != null) return widget.viewBuilder!(post);
//     return Column(
//       children: [
//         openedTitleBuilder(post),
//         contentBuilder(post),
//         buttonBuilder(post),
//         commentEditBuilder(post, WPComment.empty()), // 부모 글의 코멘트 창. 항상 보여 줌.
//         for (final comment in post.comments) commentViewBuilder(post, comment)
//       ],
//     );
//   }

//   Widget commentViewBuilder(WPPost post, WPComment comment) {
//     if (widget.commentViewBuilder != null) return widget.commentViewBuilder!(post, comment);
//     return Container(
//       margin: EdgeInsets.only(left: commentLeftMargin(comment)),
//       child: Column(
//         children: [
//           commentMetaBuilder(comment),
//           commentContentBuilder(comment),
//           commentButtonBuilder(comment),
//           if (comment.mode == 'reply') ...[
//             commentEditBuilder(post, WPComment.empty(), parent: comment),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget commentButtonBuilder(WPComment comment) {
//     return postAndCommentButtonBuilder(comment);
//   }

//   /// 글 내용 표시 빌더
//   ///
//   /// 텍스트와 사진(파일)의 위치를 아래/위로 변경 할 수 있도록 하나의 빌더에서 같이 표현한다.
//   Widget contentBuilder(WPPost post) {
//     if (widget.contentBuilder != null) return widget.contentBuilder!(post);
//     return Container(
//       padding: EdgeInsets.all(16),
//       width: double.infinity,
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.only(bottom: 8),
//             padding: EdgeInsets.all(16),
//             width: double.infinity,
//             color: Colors.brown[50],
//             child: Text(post.content),
//           ),
//           for (final f in post.files) CacheImage(f.url, width: double.infinity, height: null),
//         ],
//       ),
//     );
//   }

//   Widget buttonBuilder(WPPost post) {
//     return postAndCommentButtonBuilder(post);
//   }

//   /// 글과 코멘트 둘다 쓰이는 버튼 빌더
//   postAndCommentButtonBuilder(dynamic post) {
//     if (widget.buttonBuilder != null) return widget.buttonBuilder!(post);
//     return Row(
//       children: [
//         if (post.isComment)
//           TextButton(
//             onPressed: () {
//               /// 코멘트 폼 열고 닫기
//               post.mode = post.mode == '' ? 'reply' : '';
//               controller.setState(() {});
//             },
//             child: Text('댓글'),
//           ),
//         TextButton(
//           onPressed: () => post.like().then((v) => setState(() => {})),
//           child: Text('좋아요 (${post.Y})'),
//         ),
//         // 싫어요는 주석 처리. 싫어요 기능은 사용하지 않음.
//         // TextButton(
//         //   onPressed: () => post.dislike().then((v) => setState(() => {})),
//         //   child: Text('싫어요 (${post.N})'),
//         // ),
//         // TextButton(onPressed: () => post.like(), child: Text('별쏘기')),
//         // TextButton(onPressed: () => post.like(), child: Text('채팅')),
//         TextButton(onPressed: () => post.like(), child: Text('신고')),
//         Spacer(),
//         PopupMenuButton<String>(
//           child: Padding(
//             padding: EdgeInsets.only(right: 16),
//             child: Icon(Icons.more_vert),
//           ),
//           initialValue: '',
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             const PopupMenuItem<String>(
//               value: 'edit',
//               child: Text('수정'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'delete',
//               child: Text('삭제'),
//             ),
//             // const PopupMenuItem<String>(
//             //   value: 'profile',
//             //   child: Text('프로필'),
//             // ),
//             // const PopupMenuItem<String>(
//             //   value: 'add-friend',
//             //   child: Text('친구 추가'),
//             // ),
//             // const PopupMenuItem<String>(
//             //   value: 'block',
//             //   child: Text('차단'),
//             // ),
//             // const PopupMenuItem<String>(
//             //   value: 'report',
//             //   child: Text('신고'),
//             // ),
//             // const PopupMenuItem<String>(
//             //   value: 'posts',
//             //   child: Text('글 목록'),
//             // ),
//             // const PopupMenuItem<String>(
//             //   value: 'comments',
//             //   child: Text('코멘트 목록'),
//             // ),
//           ],
//           onSelected: (String value) async {
//             try {
//               if (value == 'edit') {
//                 if (post.isComment) {
//                   /// 코멘트 수정.
//                   openCommentEditBuilder(post);
//                 } else {
//                   /// 글
//                   controller.showPostEditForm(post);
//                 }
//               }
//               if (value == 'delete') {
//                 await post.delete();
//                 setState(() {});
//               }
//             } catch (e) {
//               widget.error(e);
//             }
//           },
//         ),
//       ],
//     );
//   }

//   /// 글 작성 폼
//   ///
//   /// 직접 디자인하려면, 아래의 함수를 복사해서 callback builder 로 만들면 된다.
//   /// 새 글 쓰기의 경우, post.idx = 0 이고, post.categoryId 에는 게시판 카테고리가 들어가 있다.
//   Widget editBuilder(WPPost post) {
//     if (widget.editBuilder != null) return widget.editBuilder!(post);
//     bool loading = false;
//     double progress = 0.0;

//     /// 자체적 state 관리. 즉, 글 작성 폼에서는 외부 상태와 상관없이 독자적으로 상태를 관리한다.
//     return StatefulBuilder(
//       builder: (_, setState) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Post on ${post.slug}'),
//               TextField(
//                 controller: TextEditingController()..text = post.title,
//                 onChanged: (v) => post.title = v,
//                 onSubmitted: (text) {},
//                 decoration: InputDecoration(
//                   labelText: "제목",
//                   hintText: "제목을 입력하세요.",
//                 ),
//               ),
//               ConstrainedBox(
//                 constraints: BoxConstraints(maxHeight: 300),
//                 child: TextField(
//                   controller: TextEditingController()..text = post.content,
//                   onChanged: (v) => post.content = v,
//                   onSubmitted: (text) {},
//                   maxLines: null,
//                   decoration: InputDecoration(
//                     labelText: "내용",
//                     hintText: "내용을 입력하세요.",
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   FileUploadIcon(
//                       entity: post.id,
//                       success: (WPFile file) {
//                         progress = 0;
//                         setState(() => post.files.add(file));
//                       },
//                       error: controller.error,
//                       progress: (p) => setState(() => progress = p)),
//                   Spacer(),
//                   ElevatedButton(onPressed: () => controller.state.edit = null, child: Text('취소')),
//                   SizedBox(width: 6),
//                   ElevatedButton(
//                       onPressed: loading
//                           ? null
//                           : () async {
//                               try {
//                                 setState(() => loading = true);
//                                 final p = await post.edit();

//                                 /// 글 쓰기 완료 후, 이 콜백을 실행하면, 글 목록으로 돌아 감.
//                                 controller.edited(p);
//                               } catch (e) {
//                                 controller.error(e);
//                               }
//                               setState(() => loading = false);
//                             },
//                       child: loading ? CircularProgressIndicator.adaptive() : Text('글 쓰기')),
//                 ],
//               ),

//               /// 사진 업로드 전송률(바 그래프) 표시
//               if (progress > 0) LinearProgressIndicator(value: progress),

//               /// 업로드 된 사진 표시
//               Container(
//                 width: double.infinity,
//                 child: Wrap(
//                   alignment: WrapAlignment.start,
//                   children: [
//                     for (final WPFile file in post.files)
//                       controller.state.fileEditBuilder(file, post, () => setState(() {})),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// Edit comment by openning a dialog.
//   /// 코멘트 수정 시, 새창을 띄워서 수정.
//   ///
//   /// 새창을 띄우는 이유는 위에 설명.
//   /// 기존의 코멘트 수정 창 코드를 활용한다.
//   /// 코멘트 수정을 할 때, 부모 글은 필요 없다.
//   /// 사진을 수정하고, 새창을 닫는다.
//   Future openCommentEditBuilder(WPComment comment) {
//     return showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.all(10.0),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Text('덧글 수정'),
//                   Spacer(),
//                   TextButton(onPressed: () => Navigator.pop(context), child: Text('취소'))
//                 ],
//               ),
//               Divider(),
//               commentEditBuilder(WPPost.empty(), comment, edited: () => Navigator.pop(context)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// 코멘트 작성 또는 수정 창
//   ///
//   /// [post] 부모 글. 참고로, 코멘트 수정을 하는 경우, [post] 는 빈 WPPost() 의 객체라도 상관 없다.
//   /// [comment] 현재 생성되는 또는 수정되는 코멘트. 생성을 하는 경우, 빈 WPComment() 의 객체를 만들어 전달하면 된다.
//   /// [parent] 현재 코멘트의 부모 코멘트. 즉, 코멘트의 코멘트를 작성하는 경우 필요.
//   Widget commentEditBuilder(
//     WPPost post,
//     WPComment comment, {
//     WPComment? parent,
//     Function? edited,
//   }) {
//     if (widget.commentEditBuilder == null) {
//       bool loading = false;
//       bool focus = true;
//       double progress = 0.0;

//       if (comment.commentId == 0) {
//         // 새 코멘트 작성
//         if (parent == null) {
//           // 부모 글 바로 밑에 (1단계) 코멘트 작성. 즉, 부모글 내용 아래에 항상 보이는 코멘트 작성 폼.
//           comment.commentParent = post.id;
//           focus = false;
//         } else {
//           // 코멘트 밑에 코멘트 작성
//           comment.commentParent = parent.commentId;
//         }
//       }
//       final content = TextEditingController(text: comment.commentContent);
//       return StatefulBuilder(builder: (_, setState) {
//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               child: Wrap(
//                 alignment: WrapAlignment.start,
//                 children: [
//                   for (final WPFile file in comment.files)
//                     fileEditBuilder(file, comment, () => setState(() {})),
//                 ],
//               ),
//             ),
//             if (progress > 0) LinearProgressIndicator(value: progress),
//             Row(
//               children: [
//                 FileUploadIcon(
//                     entity: comment.commentId,
//                     success: (WPFile file) {
//                       progress = 0;
//                       setState(() => comment.files.add(file));
//                     },
//                     error: controller.error,
//                     progress: (p) => setState(() => progress = p)),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       TextField(
//                         autofocus: focus,
//                         controller: content,
//                         maxLines: null,
//                         onChanged: (v) => setState(() => null),
//                         decoration: InputDecoration(
//                           isDense: true,
//                           contentPadding:
//                               const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 40),
//                           hintText: "Input comment.",
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(3.0),
//                             borderSide: BorderSide(
//                               color: Colors.grey[800]!,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(3.0),
//                             borderSide: BorderSide(
//                               color: Colors.blueGrey,
//                               width: 1.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                       if (content.text != '' || comment.files.length > 0)
//                         Positioned(
//                           top: 0,
//                           bottom: 0,
//                           right: -2,
//                           child: IconButton(
//                             onPressed: () async {
//                               setState(() => loading = true);
//                               try {
//                                 comment.commentContent = content.text;
//                                 await comment.edit(post);

//                                 /// 코멘트의 코멘트를 쓰는 경우, 코멘트 생성 후, 부모 mode='' 으로 해서, 입력 창 감추기
//                                 if (parent != null) parent.mode = '';
//                                 comment.mode = '';

//                                 /// 글 수정 완료 콜백
//                                 if (edited != null) edited();
//                                 controller.setState(() {});
//                               } catch (e) {
//                                 controller.error(e);
//                               }

//                               setState(() => loading = false);
//                             },
//                             icon: loading ? CircularProgressIndicator.adaptive() : Icon(Icons.send),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 16),
//               ],
//             )
//           ],
//         );
//       });
//     } else {
//       return widget.commentEditBuilder!(post, comment, parent, edited);
//     }
//   }

//   commentMetaBuilder(WPComment comment) {
//     if (widget.commentMetaBuilder == null) {
//       return Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16),
//         color: Colors.black54,
//         child: Text(
//           'Comment No. ${comment.commentId}: depth: ${comment.depth}, ${comment.shortDateTime}',
//           style: TextStyle(color: Colors.white),
//         ),
//       );
//     } else {
//       return widget.commentMetaBuilder!(comment);
//     }
//   }

//   commentContentBuilder(WPComment comment) {
//     if (widget.commentContentBuilder != null) return widget.commentContentBuilder!(comment);
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16),
//       color: Colors.black54,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${comment.commentContent}',
//             style: TextStyle(color: Colors.white),
//           ),
//           for (final f in comment.files) CacheImage(f.url, width: double.infinity, height: null),
//         ],
//       ),
//     );
//   }

//   double commentLeftMargin(WPComment comment) {
//     switch (comment.depth) {
//       case 0:
//       case 1:
//         return 0;
//       case 2:
//         return 32;
//       case 3:
//         return 48;
//       case 4:
//         return 60;
//       default:
//         return 68;
//     }
//   }

//   /// 파일 편집
//   ///
//   /// 글/코멘트 작성 폼에서, 파일을 업로드 한 후, 파일을 표시하고, 삭제 아이콘을 표시한다.
//   /// 그리고 삭제 버튼이 눌러지면 삭제하고 [deleted] 콜백을 호출한다. 콜백에서는 화면 랜더링을 하면 된다.
//   Widget fileEditBuilder(WPFile file, dynamic parent, Function deleted) {
//     if (widget.fileEditBuilder == null) {
//       return Stack(
//         children: [
//           CacheImage(file.url),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: IconButton(
//               onPressed: () async {
//                 try {
//                   final re = await showDialog(
//                       context: context,
//                       builder: (_) => confirmDialogBuilder(_, title: '삭제하시겠습니까?'));
//                   if (re == false) return;
//                   await file.delete(parent);
//                   deleted();
//                 } catch (e) {
//                   controller.error(e);
//                 }
//               },
//               icon: Icon(
//                 Icons.highlight_remove,
//                 color: Colors.red[700],
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return widget.fileEditBuilder!(file, parent, deleted);
//     }
//   }

//   /// 예/아니오를 선택하는 확인 창
//   confirmDialogBuilder(BuildContext context, {String title = '제목'}) {
//     if (widget.confirmDialogBuilder != null) return widget.confirmDialogBuilder!();
//     return AlertDialog(
//       title: Text(title, style: TextStyle(fontSize: 16)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min, // 다이얼로그 크기를 딱 맞게 조절한다.
//         children: [
//           Row(
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: Text('예'),
//               ),
//               SizedBox(width: 6),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: Text('아니오'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
