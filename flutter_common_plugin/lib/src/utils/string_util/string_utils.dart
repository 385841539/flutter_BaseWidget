class StringUtils {
  static bool isEmpty(String text) {
    return text == null || text.isEmpty;
  }

  static bool isNotEmpty(String text) {
    return text != null && text.isNotEmpty;
  }

  static bool startWithText(String content, String startText, {int index = 0}) {
    if (isEmpty(content)) return false;

    return content.startsWith(startText, index);
  }

  static bool endWithText(String content, String startText) {
    if (isEmpty(content)) return false;

    return content.endsWith(startText);
  }
}
