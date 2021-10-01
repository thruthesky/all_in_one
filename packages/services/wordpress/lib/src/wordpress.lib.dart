int toInt(String? text) {
  if (text == null) return 0;
  return int.tryParse(text) ?? 0;
}
