import 'package:intl/intl.dart';

extension DateTimeToString on DateTime {
  String formatToDayMonthYearString() {
    final _stringToDateTime = DateFormat('dd/MM/yyyy');
    return _stringToDateTime.format(this).toString();
  }

  String formatDateAndTime() {
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(this);
    return formattedDate;
  }
}

extension StringToDateTime on String {
  DateTime convertToDateTime() {
    final _stringToDateTime = DateFormat('yyyy-MM-dd HH:mm');
    return _stringToDateTime.parse(this);
  }

  DateTime convertToDateTimeddMMYY() {
    final _stringToDateTime = DateFormat('dd/MM/yyyy');
    return _stringToDateTime.parse(this);
  }

  DateTime convertToYearMonthDay() {
    final _stringToDateTime = DateFormat('yyyy-MM-dd');
    return _stringToDateTime.parse(this);
  }

  String formatToYearMonthDayString() {
    final _stringToDateTime = DateFormat('yyyy/MM/dd');
    return _stringToDateTime.format(DateTime.parse(this)).toString();
  }

  String formatToTimeString() {
    final _stringToTime = DateFormat('HH:mm');
    return _stringToTime.format(DateTime.parse(this)).toString();
  }

  DateTime convertToTime() {
    final _stringToTime = DateFormat('HH:mm');
    return _stringToTime.parse(this);
  }
}

extension LongToDateString on int {
  String formatLongToDateTimeString() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt); // 31/12/2000, 22:00
  }
}
