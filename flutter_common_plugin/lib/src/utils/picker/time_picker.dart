import 'package:flutter/cupertino.dart';
import 'package:flutter_common_plugin/src/utils/soft_keyboard_util.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class FBTimerPicker {
  static Future<DateTime> showTimePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateChangedCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.zh,
    DateTime currentTime,
    DatePickerTheme theme,
  }) {
    SoftKeyBoardUtil.unFocus(context);
    if (minTime == null) {
      minTime = DateTime(1900, 1, 1);
    }

    if (maxTime == null) {
      maxTime = DateTime.now();
    }
    if (currentTime == null) {
      currentTime = DateTime.now();
    }
    return DatePicker.showDatePicker(context,
        showTitleActions: showTitleActions,
        minTime: minTime,
        maxTime: maxTime,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        currentTime: currentTime,
        theme: theme);
  }
}
