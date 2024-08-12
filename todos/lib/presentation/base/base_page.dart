import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:todos/presentation/base/base_page_mixin.dart';

import '../../core/error/exceptions.dart';
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

abstract class BasePageState<T> extends State with BasePageMixin {
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

  void listenStateChanged(AsyncValue<dynamic>? prevState,AsyncValue<dynamic> state) async {
    state.whenOrNull(error: (error, _) async {
      if (error is IOException) {
        showAlert(
          context: context,
          message: error.errorMessage ?? '',
          primaryColor: AppColors.primaryColor,
        );
        return;
      }
    });
  }

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
