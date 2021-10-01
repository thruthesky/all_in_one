typedef Json = Map<String, dynamic>;

int toInt(String text) {
  return int.tryParse(text) ?? 0;
}
