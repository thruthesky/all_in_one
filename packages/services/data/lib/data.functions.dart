/// 공공데이터 Tour Api 에서 검색 결과에서 어떤 경우 mapx, mapy 가 문자열로 넘어 온다. 또 어떤 경우는 숫자이다.
toDouble(dynamic v) {
  if (v is String) {
    return double.parse(v);
  } else {
    return v;
  }
}

/// 공공데이터 Tour Api 에서 검색 결과에서 zipcode 의 결과 값이 어떤 경우는 String, 어떤 경우는 int 이다.
toString(dynamic v) {
  if (v is int) return v.toString();
  return v;
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
