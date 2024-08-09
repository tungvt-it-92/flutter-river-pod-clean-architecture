import 'package:todos/core/utils/validations.dart';
import 'package:flutter/services.dart';

List<TextInputFormatter> nameFormatter = [
  LengthLimitingTextInputFormatter(maxLengthName),
];

List<TextInputFormatter> onlyNumberFormatter = [
  FilteringTextInputFormatter.allow(
      RegExp(phoneNumberRegex)), // only allow number
];

List<TextInputFormatter> passwordFormatter = [
  FilteringTextInputFormatter.deny(RegExp(r"[ ]")),
  LengthLimitingTextInputFormatter(maxLengthPassword),
  FilteringTextInputFormatter.allow(RegExp(phoneNumberRegex))
];

