import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/usecase/get_todos_usecase.dart';
import 'package:todos/presentation/base/base_page.dart';
import 'package:todos/presentation/page/todo_list/index.dart';
import 'package:todos/presentation/page/todo_list/widget/todo_item_widget.dart';
import 'package:todos/presentation/resources/index.dart';
import 'package:todos/presentation/widgets/index.dart';
import '../unit_test_hepler.dart';

class MockGetTodosUseCase extends Mock implements GetTodosUseCase {}

main() {
  late GetTodosUseCase mockGetTodosUseCase;
  final todos = [
    TodoModel(
      id: 3,
      title: 'title-1',
      description: 'description-1',
      createdDate: DateTime.now(),
      isFinished: false,
    ),
    TodoModel(
      id: 4,
      title: 'title-2',
      description: 'description-2',
      createdDate: DateTime.now(),
      isFinished: true,
    ),
  ];
  setUp(() async {
    mockGetTodosUseCase = MockGetTodosUseCase();
    await AppLocalizations.shared.reloadLanguageBundle(languageCode: 'en');
  });

  tearDown(() {
    reset(mockGetTodosUseCase);
  });

  testWidgets('TodoListPage should show list todos', (tester) async {
    when(() => mockGetTodosUseCase.call())
        .thenAnswer((_) => Future.value(Right(todos)));

    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getTodosUseCaseAutoDisposeFamilyProvider
                .overrideWith((ref, arg) => mockGetTodosUseCase),
          ],
          child: generateTestApp(
            const TodoListPage(pageTag: PageTag.allTodo),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(NoDataMessageWidget), findsNothing);
      expect(find.byType(TodoItemWidget), findsExactly(2));
      final firstTodoItem = find.byType(TodoItemWidget).first;
      final secondTodoItem = find.byType(TodoItemWidget).last;

      expect(
        find.descendant(
          of: firstTodoItem,
          matching:
              find.widgetWithIcon(IconButton, Icons.radio_button_unchecked),
        ),
        findsOne,
      );
      expect(
        find.descendant(
          of: firstTodoItem,
          matching: find.text(todos[0].title),
        ),
        findsOne,
      );
      expect(
        find.descendant(
          of: secondTodoItem,
          matching: find.widgetWithIcon(IconButton, Icons.done),
        ),
        findsOne,
      );
      expect(
        find.descendant(
          of: secondTodoItem,
          matching: find.text(todos[1].title),
        ),
        findsOne,
      );
    });
  });

  testWidgets('TodoListPage should show empty message', (tester) async {
    when(() => mockGetTodosUseCase.call())
        .thenAnswer((_) => Future.value(const Right([])));

    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getTodosUseCaseAutoDisposeFamilyProvider
                .overrideWith((ref, arg) => mockGetTodosUseCase),
          ],
          child: generateTestApp(
            const TodoListPage(pageTag: PageTag.allTodo),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TodoItemWidget), findsNothing);
      expect(find.byType(NoDataMessageWidget), findsOne);
      expect(find.text('There is no data'), findsOne);
      expect(
        find.widgetWithText(NoDataMessageWidget, 'There is no data'),
        findsOne,
      );
      expect(
        find.descendant(
          of: find.byType(NoDataMessageWidget),
          matching: find.text('There is no data'),
        ),
        findsOne,
      );
    });
  });
}
