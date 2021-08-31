/// 어떤 경우 mapx, mapy 가 문자열로 넘어 온다. 또 어떤 경우는 숫자이다.
toDouble(dynamic v) {
  if (v is String) {
    return double.parse(v);
  } else {
    return v;
  }
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
