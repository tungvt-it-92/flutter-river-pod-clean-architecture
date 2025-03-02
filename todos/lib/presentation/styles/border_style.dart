import 'package:flutter/material.dart';

import 'index.dart';

UnderlineInputBorder underlineBorder({
  double size = 0.2,
  Color color = Colors.green,
}) {
  return UnderlineInputBorder(
    borderSide: BorderSide(width: size, color: color),
  );
}

OutlineInputBorder outlineBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
);
