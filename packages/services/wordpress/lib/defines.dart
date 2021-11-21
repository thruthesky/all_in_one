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
// const ERROR_IGNORED = 'ERROR_IGNORED';
const ERROR_CACHE_DATA = 'ERROR_CACHE_DATA';
const ERROR_NO_MORE_QUESTION = 'ERROR_NO_MORE_QUESTION';
const ERROR_TOKEN_UPDATE = 'ERROR_TOKEN_UPDATE';

/// Dio 에서 서버로 접속하지 못하는 경우,
/// 예) 인터넷에 연결되지 않은 경우, 서버가 다운된 경우
///
/// 특히, ERROR_DIO_HOST_LOOK_UP 은 인터넷이 연결되지 않을 경우 주로 발생하는 것으로
/// 한 화면에서 여러 글을 가져오기 위해서, 서버로 여러번 접속 하는 경우, 중복된 에러 창에 의해서 화면이
/// 검게 나올 수 있는데, 이 때 한번만 표시를 할 수 있도록 하면 좋다.
// const ERROR_DIO_FAILED_HOST_LOOK_UP = 'ERROR_FAILED_HOST_LOOK_UP';

/// Dio 에서 서버로 SSL 연결 실패
/// 예) https 로 접속해야하는데, http 로 접속한 경우
// const ERROR_DIO_CERTIFICATE_VERIFY_FAILED = 'ERROR_CERTIFICATE_VERIFY_FAILED';

/// 서버의 응답이 JSON 이 아닌 경우,
/// 예) 서버에서 PHP 에러가 나서, 에러 메세지가 리턴된 경우.
// const ERROR_DIO_NOT_JSON_RESPONSE = 'ERROR_NOT_JSON_RESPONSE';
