import 'package:flutter/material.dart';

Widget generateTestApp(Widget widget) {
  return MaterialApp(
    localizationsDelegates: const [
      DefaultMaterialLocalizations.delegate,
    ],
    home: Directionality(
      textDirection: TextDirection.ltr,
      child: widget,
    ),
  );
}
