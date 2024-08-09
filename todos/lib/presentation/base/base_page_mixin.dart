import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos/presentation/resources/index.dart';
import 'package:todos/presentation/resources/localization/app_localization.dart';
import 'package:todos/presentation/styles/index.dart';

import '../widgets/index.dart';

export 'package:flutter/material.dart';
export 'package:todos/presentation/resources/icons/app_images.dart';
export 'package:todos/presentation/resources/localization/app_localization.dart';
export 'package:todos/presentation/styles/app_colors.dart';
export 'package:todos/presentation/styles/index.dart';
export 'package:todos/presentation/styles/text_style.dart';

mixin BasePageMixin {
  Future<void> showSnackBarMessage(String msg, BuildContext context) async {
    final snackBar = SnackBar(
      backgroundColor: AppColors.primaryColor,
      content: Container(
        height: 50,
        color: AppColors.primaryColor,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(msg, style: bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  hideKeyboard(context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<bool> showAlert(
      {required BuildContext context,
      String? title,
      required String message,
      String? okActionTitle,
      String? cancelTitle,
      TextStyle? titleStyle,
      TextStyle? messageStyle,
      String? image,
      bool? dismissWithBackPress,
      Color primaryColor = AppColors.primaryColor}) async {
    final result = await _showAlert(
        context: context,
        message: message,
        title: title,
        okActionTitle: okActionTitle,
        cancelTitle: cancelTitle,
        image: image,
        titleStyle: titleStyle,
        dismissWithBackPress: dismissWithBackPress,
        messageStyle: messageStyle,
        primaryColor: primaryColor);
    return result;
  }

  buildSeparator({EdgeInsets padding = const EdgeInsets.all(0), double height = 0.5, Color color = AppColors.gray}) {
    return Padding(
      padding: padding,
      child: Container(
        height: height,
        color: color,
      ),
    );
  }

  buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  buildBottomLoadMore({Color? backgroundColor}) {
    return Container(
      alignment: Alignment.center,
      color: backgroundColor ?? AppColors.gray.withAlpha(150),
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  Widget buildShimmer({int count = 20}) {
    final children = List.generate(count, (index) => const ShimmerItemWidget());
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Future<bool> _showAlert(
      {required BuildContext context,
      String? title,
      required String message,
      String? okActionTitle,
      String? cancelTitle,
      TextStyle? titleStyle,
      TextStyle? messageStyle,
      bool? dismissWithBackPress,
      String? image,
      Color primaryColor = AppColors.primaryColor}) async {
    List<Widget> actions = [];
    if (cancelTitle?.isNotEmpty ?? false) {
      final cancelWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: RoundContainer(
          allRadius: 10,
          height: 44,
          borderColor: AppColors.neutral4,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: AutoSizeText(cancelTitle!,
                  textAlign: TextAlign.center,
                  style: titleMedium.copyWith(color: AppColors.neutral1, fontSize: 12, fontWeight: FontWeight.w700)),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
          ),
        ),
      );
      actions.add(cancelWidget);
    }

    final okWidget = Padding(
      padding: const EdgeInsets.all(10),
      child: RoundContainer(
        allRadius: 10,
        height: 44,
        color: primaryColor,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: AutoSizeText(okActionTitle ?? "OK",
                textAlign: TextAlign.center, style: titleMedium.copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            onPressed: () {
              return Navigator.of(context).pop(true);
            },
          ),
        ),
      ),
    );
    actions.add(okWidget);
    final result = await showGeneralDialog<bool>(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RoundContainer(
                      allRadius: 16,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: (image != null) ? 30 : 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Text(
                              title ?? '',
                              textAlign: TextAlign.center,
                              style: titleStyle ??
                                  titleMedium.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Text(message,
                                textAlign: TextAlign.center,
                                style: messageStyle ??
                                    titleMedium.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF666666),
                                    )),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: actions,
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
    return result ?? false;
  }

  Future<dynamic> showWidgetDialog(
      {required BuildContext context,
      required Widget child,
      EdgeInsets padding = const EdgeInsets.all(30.0),
      EdgeInsets contentMargin = const EdgeInsets.only(
        top: 15,
        left: 22,
        right: 22,
        bottom: 25,
      )}) async {
    return showGeneralDialog(
        pageBuilder: (context, animation1, animation2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: padding,
                    child: RoundContainer(
                      allRadius: 16,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: contentMargin,
                            child: child,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
            scale: a1.value,
          );
        });
  }
}
