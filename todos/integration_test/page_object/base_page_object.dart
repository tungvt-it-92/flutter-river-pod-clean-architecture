import 'package:flutter_test/flutter_test.dart';

class BasePageObject {
  late WidgetTester tester;

  BasePageObject({
    required this.tester,
  });

  click(Finder target) async {
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  enterText(Finder textField, String content) async {
    await tester.enterText(textField, content);
  }

  clickOnButtonText({ required String buttonName }) async {
    final button = find.text(buttonName);
    await click(button);
  }

  drag({ required Type type, required Offset offset} ) async {
    await tester.drag(find.byType(type), offset);
    await tester.pumpAndSettle();
  }
}