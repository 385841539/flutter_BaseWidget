class StringUtils {
  static bool isEmpty(String text) {
    return text == null || text.isEmpty;
  }

  static bool isNotEmpty(String text) {
    return text != null && text.isNotEmpty;
  }
}
