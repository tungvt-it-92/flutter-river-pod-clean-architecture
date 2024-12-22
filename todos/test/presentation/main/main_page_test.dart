
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/usecase/get_todos_usecase.dart';
import 'package:todos/presentation/page/main/main_page.dart';
import 'package:todos/presentation/page/todo_list/widget/todo_item_widget.dart';
import 'package:todos/presentation/resources/index.dart';
import 'package:todos/presentation/utils/index.dart';
import 'package:todos/presentation/widgets/index.dart';

import '../unit_test_hepler.dart';

class MockGetTodosUseCase extends Mock implements GetTodosUseCase {}


main() {
  late GetTodosUseCase mockGetTodosUseCase;
  final finishedTodo = TodoModel(
    id: 3,
    title: 'finished',
    description: 'description-1',
    createdDate: DateTime.now(),
    isFinished: true,
  );
  final doingTodo = TodoModel(
    id: 4,
    title: 'doing',
    description: 'description-1',
    createdDate: DateTime.now(),
    isFinished: false,
  );

  setUp(() async {
    await AppLocalizations.shared.reloadLanguageBundle(languageCode: 'en');
    mockGetTodosUseCase = MockGetTodosUseCase();
    when(() => mockGetTodosUseCase.call()).thenAnswer((_) => Future.value(Right([finishedTodo, doingTodo])));
    when(() => mockGetTodosUseCase.call(isFinished: true)).thenAnswer((_) => Future.value(Right([finishedTodo])));
    when(() => mockGetTodosUseCase.call(isFinished: false)).thenAnswer((_) => Future.value(Right([doingTodo])));
  });

  tearDown(() {
    reset(mockGetTodosUseCase);
  });

  testWidgets('MainPage', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
          ProviderScope(
            overrides: [
              getTodosUseCaseAutoDisposeFamilyProvider.overrideWith((ref, arg) => mockGetTodosUseCase )
            ],
            child: generateTestApp(const MainPage(pageTag: PageTag.main),
            ),
          )
      );

      await tester.pumpAndSettle();

      expect(find.byType(NoDataMessageWidget), findsNothing);
      expect(find.byType(TodoItemWidget), findsExactly(2));

      await tester.tap(find.byIcon(Icons.pending_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(NoDataMessageWidget), findsNothing);
      expect(find.byType(TodoItemWidget), findsExactly(1));
      expect(find.text('doing'), findsOne);

      await tester.tap(find.byIcon(Icons.done_all));
      await tester.pumpAndSettle();
      expect(find.byType(NoDataMessageWidget), findsNothing);
      expect(find.byType(TodoItemWidget), findsExactly(1));
      expect(find.text('finished'), findsOne);

      await tester.tap(find.byIcon(Icons.all_out));
      await tester.pumpAndSettle();
      expect(find.byType(TodoItemWidget), findsExactly(2));
    });
  });
}