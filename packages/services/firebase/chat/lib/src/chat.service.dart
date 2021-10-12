class ChatService {
  /// Singleton
  static ChatService? _instance;
  static ChatService get instance {
    if (_instance == null) {
      _instance = ChatService();
    }
    return _instance!;
  }

  String? loginUserUid;
  String? loginUserName;
  String? loginUserPhotoUrl;

  /// Update current login user informatoin
  ///
  /// This method can be invoked many times to update user information lively.
  updateLoginUser({String? loginUserUid, String? loginUserName, String? loginUserPhotoUrl}) {
    this.loginUserUid = loginUserUid;
    this.loginUserName = loginUserName;
    this.loginUserPhotoUrl = loginUserPhotoUrl;
  }
}
