import 'package:intl/intl.dart';

extension DateTimeToString on DateTime {
  String formatToDayMonthYearString() {
    final stringToDateTime = DateFormat('dd/MM/yyyy');
    return stringToDateTime.format(this).toString();
  }

  String formatDateAndTime() {
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(this);
    return formattedDate;
  }
}

extension StringToDateTime on String {
  DateTime convertToDateTime() {
    final stringToDateTime = DateFormat('yyyy-MM-dd HH:mm');
    return stringToDateTime.parse(this);
  }

  DateTime convertToDateTimeddMMYY() {
    final stringToDateTime = DateFormat('dd/MM/yyyy');
    return stringToDateTime.parse(this);
  }

  DateTime convertToYearMonthDay() {
    final stringToDateTime = DateFormat('yyyy-MM-dd');
    return stringToDateTime.parse(this);
  }

  String formatToYearMonthDayString() {
    final stringToDateTime = DateFormat('yyyy/MM/dd');
    return stringToDateTime.format(DateTime.parse(this)).toString();
  }

  String formatToTimeString() {
    final stringToTime = DateFormat('HH:mm');
    return stringToTime.format(DateTime.parse(this)).toString();
  }

  DateTime convertToTime() {
    final stringToTime = DateFormat('HH:mm');
    return stringToTime.parse(this);
  }
}

extension LongToDateString on int {
  String formatLongToDateTimeString() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt); // 31/12/2000, 22:00
  }
}
