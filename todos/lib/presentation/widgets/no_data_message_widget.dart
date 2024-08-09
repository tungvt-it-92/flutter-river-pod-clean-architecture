import 'package:flutter/widgets.dart';
import '../resources/localization/app_localization.dart';
import '../styles/index.dart';

class NoDataMessageWidget extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  const NoDataMessageWidget({this.title, this.style, super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title ?? AppLocalizations.shared.commonMessageNoData,
          style: style ??
              titleMedium.copyWith(
                  color: AppColors.neutral2,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
    );
  }
}
