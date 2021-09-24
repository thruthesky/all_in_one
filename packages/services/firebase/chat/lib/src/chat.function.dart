bool isImageUrl(String? t) {
  if (t == null || t == '') return false;
  if (t.startsWith('http://') || t.startsWith('https://')) {
    if (t.endsWith('.jpg') ||
        t.endsWith('.jpeg') ||
        t.endsWith('.gif') ||
        t.endsWith('.png') ||
        t.contains('f=jpg') ||
        t.contains('f=jpeg') ||
        t.contains('f=gif') ||
        t.contains('f=png')) {
      return true;
    }
  }
  return false;
}
