import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/PickerLocalizations.dart';

class CustomDateTimePickerAdapter extends PickerAdapter<DateTime> {
  /// display type, ref: columnType
  final int type;

  /// Whether to display the month in numerical form.If true, months is not used.
  final bool isNumberMonth;

  /// custom months strings
  final List<String> months;

  /// Custom AM, PM strings
  final List<String> strAMPM;

  /// year begin...end.
  final int yearBegin, yearEnd;

  /// hour min ... max, min >= 0, max <= 23, max > min
  final int minHour, maxHour;

  /// minimum datetime
  final DateTime minValue, maxValue;

  /// jump minutes, user could select time in intervals of 30min, 5mins, etc....
  final int minuteInterval;

  /// Year, month, day suffix
  final String yearSuffix,
      monthSuffix,
      daySuffix,
      hourSuffix,
      minSuffix,
      secondSuffix;

  /// use two-digit year, 2019, displayed as 19
  final bool twoDigitYear;

  /// year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  final List<int> customColumnType;

  static const List<String> MonthsList_EN = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> MonthsList_EN_L = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  CustomDateTimePickerAdapter({
    Picker picker,
    this.type = 0,
    this.isNumberMonth = false,
    this.months = MonthsList_EN,
    this.strAMPM,
    this.yearBegin = 1900,
    this.yearEnd = 2100,
    this.value,
    this.minValue,
    this.maxValue,
    this.minHour,
    this.maxHour,
    this.yearSuffix,
    this.monthSuffix,
    this.daySuffix,
    this.hourSuffix,
    this.minSuffix,
    this.secondSuffix,
    this.minuteInterval,
    this.customColumnType,
    this.twoDigitYear = false,
  }) : assert(minuteInterval == null ||
            (minuteInterval >= 1 &&
                minuteInterval <= 30 &&
                (60 % minuteInterval == 0))) {
    super.picker = picker;
    _yearBegin = yearBegin;
    if (minValue != null && minValue.year > _yearBegin) {
      _yearBegin = minValue.year;
    }
    // Judge whether the day is in front of the month
    // If in the front, set "needUpdatePrev" = true
    List<int> _columnType;
    if (customColumnType != null)
      _columnType = customColumnType;
    else
      _columnType = columnType[type];
    var month = _columnType.indexWhere((element) => element == 1);
    var day = _columnType.indexWhere((element) => element == 2);
    _needUpdatePrev = day < month;
  }

  int _col = 0;
  int _colAP = -1;
  int _colHour = -1;
  int _colDay = -1;
  int _yearBegin = 0;
  bool _needUpdatePrev = false;

  /// Currently selected value
  DateTime value;

  // but it can improve the performance, so keep it.
  static const List<List<int>> lengths = const [
    [12, 31, 0],
    [24, 60],
    [24, 60, 60],
    [12, 60, 2],
    [12, 31, 0, 24, 60],
    [12, 31, 0, 12, 60, 2],
    [12, 31, 0, 24, 60, 60],
    [0, 12, 31],
    [0, 12, 31, 24, 60],
    [0, 12, 31, 24, 60, 60],
    [0, 12, 31, 2, 12, 60],
    [0, 12],
    [31, 12, 0],
    [0],
  ];

  static const Map<int, int> columnTypeLength = {
    0: 0,
    1: 12,
    2: 31,
    3: 24,
    4: 60,
    5: 60,
    6: 2,
    7: 12
  };

  /// year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  static const List<List<int>> columnType = const [
    [1, 2, 0],
    [3, 4],
    [3, 4, 5],
    [7, 4, 6],
    [1, 2, 0, 3, 4],
    [1, 2, 0, 7, 4, 6],
    [1, 2, 0, 3, 4, 5],
    [0, 1, 2],
    [0, 1, 2, 3, 4],
    [0, 1, 2, 3, 4, 5],
    [0, 1, 2, 6, 7, 4],
    [0, 1],
    [2, 1, 0],
    [0],
  ];

  // static const List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

  // 获取当前列的类型
  int getColumnType(int index) {
    if (customColumnType != null) return customColumnType[index];
    List<int> items = columnType[type];
    if (index >= items.length) return -1;
    return items[index];
  }

  @override
  int getLength() {
    int v = customColumnType == null
        ? lengths[type][_col]
        : columnTypeLength[customColumnType[_col]];
    if (v == 0) {
      int ye = yearEnd;
      if (maxValue != null) ye = maxValue.year;
      return ye - _yearBegin + 1;
    }
    if (v == 31) return _calcDateCount(value.year, value.month);
    int _type = getColumnType(_col);
    switch (_type) {
      case 3: // hour
        if ((minHour != null && minHour >= 0) ||
            (maxHour != null && maxHour <= 23))
          return (maxHour ?? 23) - (minHour ?? 0) + 1;
        break;
      case 4: // minute
        if (minuteInterval != null && minuteInterval > 1)
          return v ~/ minuteInterval;
        break;
      case 7: // hour am/pm
        if ((minHour != null && minHour >= 0) ||
            (maxHour != null &&
                maxHour <= 23)) if (_colAP == null || _colAP < 0) {
          // I don't know am or PM
          return 12;
        } else {
          var _min = 0;
          var _max = 0;
          if (picker.selecteds[_colAP] == 0) {
            // am
            _min = minHour == null
                ? 1
                : minHour >= 12
                    ? 12
                    : minHour + 1;
            _max = maxHour == null
                ? 12
                : maxHour >= 12
                    ? 12
                    : maxHour + 1;
          } else {
            // pm
            _min = minHour == null
                ? 1
                : minHour >= 12
                    ? 24 - minHour - 12
                    : 1;
            _max = maxHour == null
                ? 12
                : maxHour >= 12
                    ? maxHour - 12
                    : 1;
          }
          return _max > _min ? _max - _min + 1 : _min - _max + 1;
        }
        break;
    }
    return v;
  }

  @override
  int getMaxLevel() {
    return customColumnType == null
        ? lengths[type].length
        : customColumnType.length;
  }

  @override
  bool needUpdatePrev(int curIndex) {
    if (_needUpdatePrev) {
      var _curType = getColumnType(curIndex);
      return _curType == 1 || _curType == 0;
    }
    return false;
  }

  @override
  void setColumn(int index) {
    //print("setColumn index: $index");
    _col = index + 1;
    if (_col < 0) _col = 0;
  }

  @override
  void initSelects() {
    if (value == null) value = DateTime.now();
    _colAP = _getAPColIndex();
    int _maxLevel = getMaxLevel();
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selecteds.add(0);
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    String _text = "";
    int colType = getColumnType(_col);
    switch (colType) {
      case 0:
        if (twoDigitYear != null && twoDigitYear) {
          _text = "${_yearBegin + index}";
          var _l = _text.length;
          _text =
              "${_text.substring(_l - (_l - 2), _l)}${_checkStr(yearSuffix)}";
        } else
          _text = "${_yearBegin + index}${_checkStr(yearSuffix)}";
        break;
      case 1:
        if (isNumberMonth) {
          _text = "${index + 1}${_checkStr(monthSuffix)}";
        } else {
          if (months != null)
            _text = "${months[index]}";
          else {
            List _months =
                PickerLocalizations.of(context).months ?? MonthsList_EN;
            _text = "${_months[index]}";
          }
        }
        break;
      case 2:
        _text = "${index + 1}${_checkStr(daySuffix)}";
        break;
      case 3:
        _text = "${intToStr(index + (minHour ?? 0))}${_checkStr(hourSuffix)}";
        break;
      case 5:
        _text = "${intToStr(index)}";
        break;
      case 4:
        if (minuteInterval == null || minuteInterval < 2)
          _text = "${intToStr(index)}${_checkStr(minSuffix)}";
        else
          _text = "${intToStr(index * minuteInterval)}";
        break;
      case 6:
        List _ampm = strAMPM ?? PickerLocalizations.of(context).ampm;
        if (_ampm == null) _ampm = const ['AM', 'PM'];
        _text = "${_ampm[index]}";
        break;
      case 7:
        _text =
            "${intToStr(index + (minHour == null ? 0 : (picker.selecteds[_colAP] == 0 ? minHour : 0)) + 1)}";
        break;
    }

    return makeText(null, _text, picker.selecteds[_col] == index);
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  int getColumnFlex(int column) {
    if (picker.columnFlex != null && column < picker.columnFlex.length)
      return picker.columnFlex[column];
    if (getColumnType(column) == 0) return 3;
    return 2;
  }

  @override
  void doShow() {
    if (_yearBegin == 0) getLength();
    var _maxLevel = getMaxLevel();
    for (int i = 0; i < _maxLevel; i++) {
      int colType = getColumnType(i);
      switch (colType) {
        case 0:
          picker.selecteds[i] = yearEnd != null && value.year > yearEnd
              ? yearEnd - _yearBegin
              : value.year - _yearBegin;
          break;
        case 1:
          picker.selecteds[i] = value.month - 1;
          break;
        case 2:
          picker.selecteds[i] = value.day - 1;
          break;
        case 3:
          picker.selecteds[i] = value.hour;
          break;
        case 4:
          picker.selecteds[i] = minuteInterval == null || minuteInterval < 2
              ? value.minute
              : value.minute ~/ minuteInterval;
          break;
        case 5:
          picker.selecteds[i] = value.second;
          break;
        case 6:
          picker.selecteds[i] = (value.hour > 12 || value.hour == 0) ? 1 : 0;
          break;
        case 7:
          picker.selecteds[i] = value.hour == 0
              ? 11
              : (value.hour > 12)
                  ? value.hour - 12 - 1
                  : value.hour - 1;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int year, month, day, h, m, s;
    year = value.year;
    month = value.month;
    day = value.day;
    h = value.hour;
    m = value.minute;
    s = value.second;
    if (type != 2 && type != 6) s = 0;

    int colType = getColumnType(column);
    switch (colType) {
      case 0:
        year = _yearBegin + index;
        break;
      case 1:
        month = index + 1;
        break;
      case 2:
        day = index + 1;
        break;
      case 3:
        h = index + (minHour ?? 0);
        break;
      case 4:
        m = (minuteInterval == null || minuteInterval < 2)
            ? index
            : index * minuteInterval;
        break;
      case 5:
        s = index;
        break;
      case 6:
        if (picker.selecteds[_colAP] == 0) {
          if (h == 0) h = 12;
          if (h > 12) h = h - 12;
        } else {
          if (h < 12) h = h + 12;
          if (h == 12) h = 0;
        }
        if (minHour != null || maxHour != null) {
          if (minHour != null && _colHour >= 0) {
            if (h < minHour) {
              picker.selecteds[_colHour] = 0;
              picker.updateColumn(_colHour);
              return;
            }
          }
          if (maxHour != null && h > maxHour) h = maxHour;
        }
        break;
      case 7:
        h = index +
            (minHour == null
                ? 0
                : (picker.selecteds[_colAP] == 0 ? minHour : 0)) +
            1;
        if (_colAP >= 0 && picker.selecteds[_colAP] == 1) h = h + 12;
        if (h > 23) h = 0;
        break;
    }
    int __day = _calcDateCount(year, month);

    bool _isChangeDay = false;
    if (day > __day) {
      day = __day;
      _isChangeDay = true;
    }
    value = DateTime(year, month, day, h, m, s);

    if (minValue != null &&
        (value.millisecondsSinceEpoch < minValue.millisecondsSinceEpoch)) {
      value = minValue;
      notifyDataChanged();
    } else if (maxValue != null &&
        value.millisecondsSinceEpoch > maxValue.millisecondsSinceEpoch) {
      value = maxValue;
      notifyDataChanged();
    } else if (_isChangeDay && _colDay >= 0) {
      doShow();
      picker.updateColumn(_colDay);
    }
  }

  int _getAPColIndex() {
    List<int> items = customColumnType ?? columnType[type];
    _colHour = items.indexWhere((e) => e == 7);
    _colDay = items.indexWhere((e) => e == 2);
    for (int i = 0; i < items.length; i++) {
      if (items[i] == 6) return i;
    }
    return -1;
  }

  int _calcDateCount(int year, int month) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 2:
        {
          if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            return 29;
          }
          return 28;
        }
    }
    return 30;
  }

  String intToStr(int v) {
    return (v < 10) ? "0$v" : "$v";
  }

  String _checkStr(String v) {
    return v == null ? "" : v;
  }
}
