import 'package:firebase_chat/src/chat.defines.dart';

import 'package:flutter/material.dart';
import 'package:firebase_chat/firebase_chat.dart';
import 'package:paginate_firestore/bloc/pagination_cubit.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  final FunctionRoomsItemBuilder itemBuilder;

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 부모 앱(위젯)에서 로그아웃 또는 로그인을 하지 않은 상태(또는 로그인을 하는데 시간이 오래걸리는 경우) 등에서
    /// 이 위젯이 빠르게 호출되면 Firebase UID 가 설정되지 않은 상태가 된다.
    /// 이와 같은 경우, 부모 위젯에서 적절히 Firebase UID 를 설정하고, 다시 랜더링을 해주어야 한다.
    if (chat.user.uid == '') return SizedBox.shrink();

    return PaginateFirestore(
      // Use SliverAppBar in header to make it sticky
      // header: const SliverToBoxAdapter(child: Text('HEADER')),
      footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),

      itemsPerPage: 20,

      reverse: false,
      //item builder type is compulsory.
      itemBuilder: (index, context, documentSnapshot) {
        final data = documentSnapshot.data() as Map?;
        final room = ChatDataModel.fromJson(data!, documentSnapshot.reference);
        return Container(
          key: ValueKey(room.otherUid),
          child: widget.itemBuilder(room),
        );
      },
      // orderBy is compulsory to enable pagination
      query: chat.roomsCol.orderBy('timestamp', descending: true),
      //Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
      // To update db data in real time.
      isLive: true,

      /// initialLoader 가 제대로 잘 동작하지 않는 것 같다.
      // initialLoader: Row(
      //   children: [Icon(Icons.local_dining), Text('맨 처음에 한번만 표시되는 로더...')],
      // ),

      /// 이것도 제대로 동작하지 않는 것 같다.
      // bottomLoader: Row(
      //   children: [Icon(Icons.timer), Text('스크롤 해서 더 많이 로드 할 때 표시되는 로더!!!')],
      // ),

      onLoaded: (PaginationLoaded loaded) {
        // print('page loaded; reached to end?; ${loaded.hasReachedEnd}');
      },
      onReachedEnd: (PaginationLoaded loaded) {
        // This is called only one time when it reaches to the end.
        // print('Yes, Reached to end!!');
      },
      onPageChanged: (int no) {
        /// onPageChanged works on [PaginateBuilderType.pageView] only.
        // print('onPageChanged() => page no; $no');
      },
      emptyDisplay: Center(child: Text('No friends, yet. Please send a message to some friends.')),
      // separator: Divider(color: Colors.blue),
    );
  }
}
