import 'package:flutter/material.dart';
import 'package:x_flutter/src/widgets/spinner.dart';
import 'package:x_flutter/x_flutter.dart';

/// 게시판 목록 및 글 작성/수정
///
/// 여러 게시판(카테고리)가 한번에 열릴 수 있다. 그래서 질문게시판->자유게시판에서 백 버튼을 눌러 질문게시판 되돌아 갈 때,
/// 질문게시판의 기존 글(및 스크롤 상태)이 유지되어야 하므로,
/// 글 목록 및 스크롤 상태를 위젯 내부에 보관해야 한다.
class ForumWidget extends StatefulWidget {
  ForumWidget({
    Key? key,
    this.categoryId = '',
    this.titleBuilder,
    this.buttonBuilder,
    this.fetch,
    required this.error,
    this.limit = 10,
  }) : super(key: key);

  final String categoryId;
  final Function? titleBuilder;
  final Function? buttonBuilder;
  final Function? fetch;
  final Function error;
  final int limit;

  @override
  _ForumWidgetState createState() => _ForumWidgetState();
}

class _ForumWidgetState extends State<ForumWidget> {
  Api api = Api.instance;
  List<PostModel> posts = [];
  int page = 0;
  bool loading = false;
  bool noMorePosts = false;

  final controller = ScrollController();
  bool get atBottom {
    return controller.offset > (controller.position.maxScrollExtent - 240);
  }

  @override
  void initState() {
    super.initState();
    _fetchPage();
    controller.addListener(() {
      if (atBottom) _fetchPage();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          } else {
            child = viewBuilder(post);
          }

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
      controller: controller,
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
        if (p.title == '') p.title = '제목이 없습니다.';
        posts.add(p);
      });
      setState(() => loading = false);
      if (posts.length < widget.limit) {
        // last page
        noMorePosts = true;
        posts.add(PostModel({})..setNoMorePosts());
      }
      setState(() {});
      if (widget.fetch != null) widget.fetch!(posts);
    } catch (e) {
      setState(() => loading = false);
      widget.error(e);
    }
  }

  /// 글 제목 빌더
  titleBuilder(PostModel post) {
    Widget child;
    if (widget.titleBuilder == null) {
      /// 기본 빌더
      if (post.open) {
        /// 글 읽기 상태
        child = ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
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
    } else {
      /// 커스텀 빌더
      child = widget.titleBuilder!(post);
    }
    return GestureDetector(child: child, onTap: () => setState(() => post.open = !post.open));
  }

  viewBuilder(PostModel post) {
    return Column(
      children: [
        titleBuilder(post),
        contentBuilder(post),
        buttonBuilder(post),
      ],
    );
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
        IconButton(
          onPressed: () => {},
          icon: Icon(Icons.more_vert),
        )
      ],
    );
  }
}
