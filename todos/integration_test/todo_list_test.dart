import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todos/main.dart';
import 'package:todos/presentation/page/main/widget/input_toto_widget.dart';
import 'package:todos/presentation/page/todo_list/index.dart';
import 'package:todos/presentation/page/todo_list/widget/todo_item_widget.dart';
import 'package:todos/presentation/resources/index.dart';
import 'package:todos/presentation/widgets/index.dart';

import 'page_object/toto_list_page_object.dart';

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await AppLocalizations.shared.reloadLanguageBundle(languageCode: 'en');
  });

  group('Should create/update/delete todo item successfully', () {
    testWidgets('should add toto item', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );
        await tester.pump();
        final todoListPO = TodoListPageObject(tester: tester);

        await todoListPO.clickOnAddNewTodoButton();
        expect(find.byType(InputTodoWidget), findsOneWidget);

        final todoItemFinder = find.descendant(
          of: find.byType(TodoListPage),
          matching: find.byType(TodoItemWidget),
        );

        await todoListPO.enterTodoTitle('Input new title');
        await todoListPO.enterTodoDescription('Input new description');
        await todoListPO.clickOnSaveButton();
        expect(todoItemFinder, findsExactly(1));
        expect(find.text('Input new title'), findsOneWidget);
        expect(find.text('Input new description'), findsOneWidget);

        await todoListPO.changeTab(tabName: 'Done');
        expect(todoItemFinder, findsNothing);
        await todoListPO.changeTab(tabName: 'All');
        await todoListPO.clickOnMarkAsDoneButton(atItemIndex: 0);
        expect(find.text('Mark this item is "Done" ?'), findsExactly(1));
        await todoListPO.clickOnButtonText(buttonName: 'OK');
        await todoListPO.changeTab(tabName: 'Done');
        expect(todoItemFinder, findsExactly(1));

        await todoListPO.changeTab(tabName: 'All');
        await todoListPO.drag(
          type: TodoItemWidget,
          offset: const Offset(-500, 0),
        );
        await todoListPO.clickOnButtonText(buttonName: 'Delete');
        expect(find.text('Are you sure to delete this note?'), findsExactly(1));
        final deleteMenuItem = find.descendant(
          of: find.byType(RoundContainer),
          matching: find.text('Delete'),
        );
        final cancelMenuItem = find.descendant(
          of: find.byType(RoundContainer),
          matching: find.text('Cancel'),
        );
        expect(deleteMenuItem, findsExactly(1));
        expect(cancelMenuItem, findsExactly(1));
        await tester.ensureVisible(deleteMenuItem);
        await todoListPO.click(deleteMenuItem);
        expect(todoItemFinder, findsExactly(0));
      });
    });
  });
}
