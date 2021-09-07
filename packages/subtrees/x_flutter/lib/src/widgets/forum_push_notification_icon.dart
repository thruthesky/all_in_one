import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_flutter/src/user.api.dart';
import 'package:x_flutter/src/widgets/popup_button.dart';
import 'package:x_flutter/src/widgets/spinner.dart';
import 'package:x_flutter/x_flutter.dart';

class ForumPushNotificationIcon extends StatefulWidget {
  ForumPushNotificationIcon(this.categoryId, {this.size});
  final String categoryId;
  final double? size;
  @override
  _ForumPushNotificationIconState createState() => _ForumPushNotificationIconState();
}

class _ForumPushNotificationIconState extends State<ForumPushNotificationIcon> {
  bool loading = true;

  @override
  void initState() {
    super.initState();

    initForumPushNotificationIcons();
  }

  initForumPushNotificationIcons() {
    if (widget.categoryId == '') return;

    /// Get latest user's profile from backend
    if (UserApi.instance.loggedIn) {
      UserApi.instance.profile().then((profile) {
        setState(() => loading = false);
      });
    } else {
      setState(() => loading = false);
    }
  }

  bool hasSubscription() {
    return UserApi.instance.user.isSubscribeTopic(NotificationOptions.post(widget.categoryId)) ||
        UserApi.instance.user.isSubscribeTopic(NotificationOptions.comment(widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return widget.categoryId != ''
        ? Container(
            child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              PopUpButton(
                items: [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          UserApi.instance.user
                                  .isSubscribeTopic(NotificationOptions.post(widget.categoryId))
                              ? Icons.notifications_on
                              : Icons.notifications_off,
                          color: Colors.blue,
                        ),
                        Text(' Post'),
                      ],
                    ),
                    value: 'post',
                  ),
                  PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            UserApi.instance.user.isSubscribeTopic(
                                    NotificationOptions.comment(widget.categoryId))
                                ? Icons.notifications_on
                                : Icons.notifications_off,
                            color: Colors.blue,
                          ),
                          Text(' Comment'),
                        ],
                      ),
                      value: 'comment'),
                ],
                icon: Icon(
                  hasSubscription() ? Icons.notifications : Icons.notifications_off,
                  color: Colors.blue,
                  size: widget.size,
                ),
                onSelected: onNotificationSelected,
              ),
              if (UserApi.instance.user
                  .isSubscribeTopic(NotificationOptions.post(widget.categoryId)))
                Positioned(
                  top: 15,
                  left: 5,
                  child: Icon(Icons.comment, size: 12, color: Colors.greenAccent),
                ),
              if (UserApi.instance.user
                  .isSubscribeTopic(NotificationOptions.comment(widget.categoryId)))
                Positioned(
                  top: 15,
                  right: 5,
                  child: Icon(Icons.comment, size: 12, color: Colors.greenAccent),
                ),
              if (loading)
                Positioned(
                  bottom: 15,
                  left: 10,
                  child: Spinner(
                    size: 10,
                  ),
                ),
            ],
          ))
        : SizedBox.shrink();
  }

  onNotificationSelected(dynamic selection) async {
    if (UserApi.instance.notLoggedIn) {
      return Get.snackbar('Notifications', 'Must Login First');
    }

    /// Show spinner
    setState(() => loading = true);
    String topic = '';
    String title = "Notification";
    if (selection == 'post') {
      topic = NotificationOptions.post(widget.categoryId);
      title = 'Post ' + title;
    } else if (selection == 'comment') {
      topic = NotificationOptions.comment(widget.categoryId);
      title = 'Comment ' + title;
    }

    final UserModel res =
        UserModel.fromJson(await MessagingApi.instance.subscribeOrUnsubscribeTopic(topic));
    await UserApi.instance.profile();

    /// Hide spinner
    setState(() => loading = false);
    String msg = res.data[topic] == 'Y' ? 'Subscribed' : 'Unsubscribed';
    Get.snackbar(title, msg);
  }
}

class NotificationOptions {
  static String notifyPost = 'notifyPost_';
  static String notifyComment = 'notifyComment_';

  static String post(String category) {
    return notifyPost + category;
  }

  static String comment(String category) {
    return notifyComment + category;
  }
}
