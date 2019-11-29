import 'package:flutter/services.dart';

/// 手机号格式话
class CNPhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ' ');
    }
    if (newTextLength >= 8) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 7) + ' ');
    }
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
