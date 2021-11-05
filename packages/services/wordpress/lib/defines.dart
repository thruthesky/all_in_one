import 'package:wordpress/models/post.model.dart';

typedef MapStringDynamic = Map<String, dynamic>;
typedef JSON = MapStringDynamic;

typedef PostsCacheCallback = void Function(List<WPPost>);

const PROFILE_PHOTO = 'profile_photo';
const COMMENT_ATTACHMENT = 'comment_attachment';
const COMMENT_POST_ID = 'comment_post_ID';

const ERROR_USER_NOT_FOUND_BY_THAT_EMAIL = 'ERROR_USER_NOT_FOUND_BY_THAT_EMAIL';
const IMAGE_NOT_SELECTED = 'IMAGE_NOT_SELECTED';
const ERROR_NOT_LOGGED_IN = 'ERROR_NOT_LOGGED_IN';
const ERROR_PROFILE_ID_MISSING = 'ERROR_PROFILE_ID_MISSING';
const ERROR_IGNORED = 'ERROR_IGNORED';
const ERROR_CACHE_DATA = 'ERROR_CACHE_DATA';
const ERROR_NO_MORE_QUESTION = 'ERROR_NO_MORE_QUESTION';
