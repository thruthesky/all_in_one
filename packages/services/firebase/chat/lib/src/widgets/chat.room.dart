import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/firebase_chat.dart';
import 'package:firebase_chat/src/chat.defines.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paginate_firestore/bloc/pagination_cubit.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({
    required this.otherUid,
    required this.onError,
    required this.onUpdateOtherUserRoomInformation,
    required this.messageBuilder,
    required this.inputBuilder,
    Key? key,
  }) : super(key: key);

  final Function onError;
  final Function onUpdateOtherUserRoomInformation;
  final MessageBuilder messageBuilder;
  final InputBuilder inputBuilder;

  /// Firebase user uid
  // final String myUid;
  final String otherUid;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool fetching = false;
  final int fetchNum = 20;
  bool noMore = false;

  List<ChatDataModel> messages = [];

  String get myUid => chat.user.uid;

  /// messages collection of chat user.
  late CollectionReference _messagesCol =
      FirebaseFirestore.instance.collection('chat/messages/$roomId');

  ///
  late CollectionReference _myRoomCol = chat.roomsCol;
  // FirebaseFirestore.instance.collection('chat/rooms/${widget.myUid}');
  late CollectionReference _otherRoomCol =
      FirebaseFirestore.instance.collection('chat/rooms/${widget.otherUid}');

  // /chat/rooms/[my-uid]/[other-uid]
  DocumentReference get _myRoomDoc => _myRoomCol.doc(widget.otherUid);

  /// /chat/rooms/[other-uid]/[my-uid]
  DocumentReference get _otherRoomDoc => _otherRoomCol.doc(myUid);

  int page = 0;

  /// Get room id from login user and other user.
  String get roomId => getMessageCollectionId(myUid, widget.otherUid);

  // // ignore: cancel_subscriptions
  // StreamSubscription<QuerySnapshot>? chatRoomSubscription;
  // late StreamSubscription ready;

  @override
  void initState() {
    super.initState();
    chat.otherUid = widget.otherUid;
    // _myRoomDoc.set({'newMessages': 0}, SetOptions(merge: true));

    /// update app icon if the user view some message.
    // ready = chat.ready.listen((re) {
    //   if (re == false) return;

    //   chatRoomSubscription = chat.roomsCol
    //       .where('newMessages', isGreaterThan: 0)
    //       .snapshots()
    //       .listen((QuerySnapshot snapshot) {
    //     int newMessages = 0;
    //     snapshot.docs.forEach((doc) {
    //       ChatDataModel room = ChatDataModel.fromJson(doc.data() as Map, null);
    //       newMessages += room.newMessages;
    //     });
    //     FlutterAppBadger.updateBadgeCount(newMessages);
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    chat.otherUid = '';
    // if (chatRoomSubscription != null) {
    //   chatRoomSubscription!.cancel();
    // }
    // ready.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: PaginateFirestore(
              // Use SliverAppBar in header to make it sticky
              // header: const SliverToBoxAdapter(child: Text('HEADER')),
              footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),

              itemsPerPage: 20,

              reverse: true,
              //item builder type is compulsory.
              itemBuilder: (index, context, documentSnapshot) {
                final data = documentSnapshot.data() as Map?;
                final message = ChatDataModel.fromJson(data!, documentSnapshot.reference);
                return widget.messageBuilder(message);
              },
              // orderBy is compulsory to enable pagination
              query: _messagesCol.orderBy('timestamp', descending: true),
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

              /// This will be invoked whenever it displays a new message. (from the login user or the other user.)
              onLoaded: (PaginationLoaded loaded) {
                // print('page loaded; reached to end?; ${loaded.hasReachedEnd}');
                // print('######################################');
                _myRoomDoc.set({'newMessages': 0}, SetOptions(merge: true));
              },
              onReachedEnd: (PaginationLoaded loaded) {
                // This is called only one time when it reaches to the end.
                // print('Yes, Reached to end!!');
              },
              onPageChanged: (int no) {
                /// onPageChanged works on [PaginateBuilderType.pageView] only.
                // print('onPageChanged() => page no; $no');
              },
              emptyDisplay: Center(child: Text('No chats, yet. Please send some message.')),
              // separator: Divider(color: Colors.blue),
            ),
          ),
          SafeArea(child: widget.inputBuilder(onSubmitText)),
        ],
      ),
    );
  }

  void onSubmitText(String text) {
    final data = {
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'from': myUid,
      'to': widget.otherUid,
    };
    _messagesCol.add(data).then((value) {});

    /// When the login user send message, clear newMessage.
    data['newMessages'] = 0;
    _myRoomDoc.set(data);

    data['newMessages'] = FieldValue.increment(1);
    _otherRoomDoc.set(data, SetOptions(merge: true)).then((value) {
      widget.onUpdateOtherUserRoomInformation(data);
    });
  }
}
