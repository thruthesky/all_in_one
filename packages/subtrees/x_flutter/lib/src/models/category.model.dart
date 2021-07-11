class CategoryModel {
  int idx;
  int userIdx;
  String id;
  String domain;
  String countryCode;
  String title;
  String description;
  String subcategories;
  int postCreateLimit;
  int commentCreateLimit;
  int readLimit;
  String banCreateOnLimit;

  /// [createPost] is the point for creating a post
  int createPost;

  /// [deletePost] is the point for deleting a post
  int deletePost;

  /// [createComment] is the point for creating a comment.
  int createComment;

  /// [deleteComment] is the point for deleting a comment.
  int deleteComment;

  int createHourLimit;
  int createHourLimitCount;
  int createDailyLimitCount;
  String listOnView;
  int noOfPostsPerPage;
  String postEditWidget;
  String postViewWidget;
  String postListHeaderWidget;
  String postListWidget;
  String paginationWidget;
  int noOfPagesOnNav;
  String returnToAfterPostEdit;
  int createdAt;
  int updatedAt;
  String postEditWidgetOption;
  List<String> subcategoriesArray;

  CategoryModel({
    this.idx = 0,
    this.userIdx = 0,
    this.id = '',
    this.domain = '',
    this.countryCode = '',
    this.title = '',
    this.description = '',
    this.subcategories = '',
    this.postCreateLimit = 0,
    this.commentCreateLimit = 0,
    this.readLimit = 0,
    this.banCreateOnLimit = '',
    this.createPost = 0,
    this.deletePost = 0,
    this.createComment = 0,
    this.deleteComment = 0,
    this.createHourLimit = 0,
    this.createHourLimitCount = 0,
    this.createDailyLimitCount = 0,
    this.listOnView = '',
    this.noOfPostsPerPage = 0,
    this.postEditWidget = '',
    this.postViewWidget = '',
    this.postListHeaderWidget = '',
    this.postListWidget = '',
    this.paginationWidget = '',
    this.noOfPagesOnNav = 0,
    this.returnToAfterPostEdit = '',
    this.createdAt = 0,
    this.updatedAt = 0,
    this.postEditWidgetOption = '',
    this.subcategoriesArray = const [],
  });

  @override
  String toString() {
    return 'CategoryModel(idx: $idx, userIdx: $userIdx, id: $id, domain: $domain, countryCode: $countryCode, title: $title, description: $description, subcategories: $subcategories, postCreateLimit: $postCreateLimit, commentCreateLimit: $commentCreateLimit, readLimit: $readLimit, banCreateOnLimit: $banCreateOnLimit, createPost: $createPost, deletePost: $deletePost, createComment: $createComment, deleteComment: $deleteComment, createHourLimit: $createHourLimit, createHourLimitCount: $createHourLimitCount, createDailyLimitCount: $createDailyLimitCount, listOnView: $listOnView, noOfPostsPerPage: $noOfPostsPerPage, postEditWidget: $postEditWidget, postViewWidget: $postViewWidget, postListHeaderWidget: $postListHeaderWidget, postListWidget: $postListWidget, paginationWidget: $paginationWidget, noOfPagesOnNav: $noOfPagesOnNav, returnToAfterPostEdit: $returnToAfterPostEdit, createdAt: $createdAt, updatedAt: $updatedAt, postEditWidgetOption: $postEditWidgetOption, subcategoriesArray: $subcategoriesArray)';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<String> subcategoriesArray = [];
    if (json['subcategoriesArray'] != null) {
      for (final c in json['subcategoriesArray']) {
        subcategoriesArray.add(c.toString());
      }
    }
    return CategoryModel(
      idx: json['idx'] ?? 0,
      userIdx: json['userIdx'] ?? 0,
      id: json['id'] ?? '',
      domain: json['domain'] ?? '',
      countryCode: json['countryCode'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subcategories: json['subcategories'] ?? '',
      postCreateLimit: json['postCreateLimit'] ?? 0,
      commentCreateLimit: json['commentCreateLimit'] ?? 0,
      readLimit: json['readLimit'] ?? 0,
      banCreateOnLimit: json['banCreateOnLimit'] ?? '',
      createPost: json['createPost'] ?? 0,
      deletePost: json['deletePost'] ?? 0,
      createComment: json['createComment'] ?? 0,
      deleteComment: json['deleteComment'] ?? 0,
      createHourLimit: json['createHourLimit'] ?? 0,
      createHourLimitCount: json['createHourLimitCount'] ?? 0,
      createDailyLimitCount: json['createDailyLimitCount'] ?? 0,
      listOnView: json['listOnView'] ?? '',
      noOfPostsPerPage: json['noOfPostsPerPage'] ?? 0,
      postEditWidget: json['postEditWidget'] ?? '',
      postViewWidget: json['postViewWidget'] ?? '',
      postListHeaderWidget: json['postListHeaderWidget'] ?? '',
      postListWidget: json['postListWidget'] ?? '',
      paginationWidget: json['paginationWidget'] ?? '',
      noOfPagesOnNav: json['noOfPagesOnNav'] ?? 0,
      returnToAfterPostEdit: json['returnToAfterPostEdit'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
      postEditWidgetOption: json['postEditWidgetOption'] ?? '',
      subcategoriesArray: subcategoriesArray,
    );
  }

  Map<String, dynamic> toJson() => {
        'idx': idx,
        'userIdx': userIdx,
        'id': id,
        'domain': domain,
        'countryCode': countryCode,
        'title': title,
        'description': description,
        'subcategories': subcategories,
        'postCreateLimit': postCreateLimit,
        'commentCreateLimit': commentCreateLimit,
        'readLimit': readLimit,
        'banCreateOnLimit': banCreateOnLimit,
        'createPost': createPost,
        'deletePost': deletePost,
        'createComment': createComment,
        'deleteComment': deleteComment,
        'createHourLimit': createHourLimit,
        'createHourLimitCount': createHourLimitCount,
        'createDailyLimitCount': createDailyLimitCount,
        'listOnView': listOnView,
        'noOfPostsPerPage': noOfPostsPerPage,
        'postEditWidget': postEditWidget,
        'postViewWidget': postViewWidget,
        'postListHeaderWidget': postListHeaderWidget,
        'postListWidget': postListWidget,
        'paginationWidget': paginationWidget,
        'noOfPagesOnNav': noOfPagesOnNav,
        'returnToAfterPostEdit': returnToAfterPostEdit,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'postEditWidgetOption': postEditWidgetOption,
        'subcategoriesArray': subcategoriesArray,
      };
}
