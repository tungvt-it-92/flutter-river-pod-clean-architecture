import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import '../utils/index.dart';

export 'package:logger/logger.dart';
export 'package:todos/presentation/utils/input_formatter.dart';
export '..//styles/index.dart';
export '../utils/index.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({
    required this.tag,
    super.key,
  });

  final PageTag tag;
}

abstract class BasePageState<T> extends State {
  late BuildContext subContext;

  bool get resizeToAvoidBottomInset => false;

  void onFocusGained(WidgetRef ref) {}
  void onForegroundGained(WidgetRef ref) {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildLayout(BuildContext context, WidgetRef ref);

  // void stateListenerHandler(BaseState state) async {
  // if (state.failure != null) {
  //   if ((state.failure!.httpStatusCode ?? 0) == accessTokenExpiredCode) {
  //     final result = await showAlert(
  //       primaryColor: AppColors.primaryColor,
  //       context: context,
  //       message: AppLocalizations.shared.commonMessageServerMaintenance,
  //     );
  //     if (result) {
  //       navigator.popToRoot(context: context);
  //       applicationBloc.dispatchEvent(AccessTokenExpiredEvent());
  //     }
  //     return;
  //   }
  //   String message = '';
  //   Logger().d('[Debug]: error ${state.failure?.message}');
  //   if (state.failure!.message == internetErrorMessage || state.failure!.message == socketErrorMessage) {
  //     message = AppLocalizations.shared.commonMessageConnectionError;
  //   } else if (state.failure!.message == serverErrorMessage) {
  //     message = AppLocalizations.shared.commonMessageServerMaintenance;
  //   } else {
  //     message = state.failure!.message ?? unknownErrorMessage;
  //   }
  //   showAlert(
  //     context: context,
  //     message: message,
  //     primaryColor: AppColors.primaryColor,
  //   );
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, _) {
      return FocusDetector(
        onFocusGained: () {
          onFocusGained(ref);
        },
        onFocusLost: () {},
        onForegroundLost: () {},
        onForegroundGained: () {
          onForegroundGained(ref);
        },
        child: Scaffold(
          // backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: buildLayout(context, ref),
        ),
      );
    });
  }

  @override
  dispose() {
    super.dispose();
  }
}
