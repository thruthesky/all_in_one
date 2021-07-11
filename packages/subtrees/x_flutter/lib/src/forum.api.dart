import 'package:x_flutter/x_flutter.dart';

class ForumApi {
  Api get api => Api.instance;

  like(int idx) {
    return vote(idx, 'Y');
  }

  dislike(int idx) {
    return vote(idx, 'N');
  }

  /// 추천/비추천
  ///
  /// 추천/비추천은 글/코멘트가 같은 루틴을 사용한다. 그래서 `post.vote` 이나 `comment.vote` 모두 동일한 Restful Api 라우트이다.
  /// 리턴 값은 { Y: 1, N: 2 } 와 같다.
  Future<Map<String, int>> vote(int idx, String choice) async {
    final re = await api.request('post.vote', {'idx': idx, 'choice': choice});

    final post = PostModel.fromJson(re);
    return {
      'Y': post.Y,
      'N': post.N,
    };
  }
}
