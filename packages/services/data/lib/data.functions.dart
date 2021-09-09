/// 공공데이터 Tour Api 에서 검색 결과에서 어떤 경우 mapx, mapy 가 문자열로 넘어 온다. 또 어떤 경우는 숫자이다.
double toDouble(dynamic v) {
  if (v == null)
    return 0;
  else if (v is String) {
    return double.parse(v);
  } else {
    return v;
  }
}

int toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int)
    return v;
  else
    return int.parse(v);
  // if (v is String) {
  //   return int.parse(v);
  // } else {
  //   return v;
  // }
}

/// 공공데이터 Tour Api 에서 검색 결과에서 zipcode 의 결과 값이 어떤 경우는 String, 어떤 경우는 int 이다.
String toString(dynamic v) {
  if (v == null)
    return '';
  else if (v is int) return v.toString();
  return v;
}

String tourApiHomepage(String? str) {
  if (str == null) return '';
  return str;
}

testSuccess(String msg) {
  print('   [SUCCESS] ====>>>> $msg');
}

testError(String msg) {
  print('   [ERROR] ====>>>> $msg');
}

testResultCode(String code, {String msg = ''}) {
  if (code == '0000')
    testSuccess(msg);
  else
    testError(msg);
}
