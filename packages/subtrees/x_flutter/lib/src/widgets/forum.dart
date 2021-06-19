import 'package:flutter/material.dart';
import 'package:x_flutter/x_flutter.dart';

class Forum extends StatefulWidget {
  const Forum({
    Key? key,
    this.categoryId = '',
  }) : super(key: key);

  final String categoryId;

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  Api api = Api.instance;

  int pageNo = 0;
  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }

  loadPosts() async {
    pageNo++;

    api.post.search({'categoryId': ''});
  }
}
