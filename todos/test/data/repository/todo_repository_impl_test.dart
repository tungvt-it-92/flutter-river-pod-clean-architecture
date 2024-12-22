import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/data/local/index.dart';
import 'package:todos/data/repository/index.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';

class MockTodoDAO extends Mock implements TodoDAO {}

main() {
  late TodoRepository todoRepository;
  late MockTodoDAO mockTodoDAO;

  setUp(() {
    mockTodoDAO = MockTodoDAO();
    final providerContainer = ProviderContainer(
      overrides: [
        todoDaoProvider.overrideWithValue(mockTodoDAO)
      ]
    );
    todoRepository = providerContainer.read(todoRepositoryProvider);
  });

  group('TodoRepositoryImpl', () {
    test('addNewTodo()', () async {
      final newTodo = TodoModel(
        id: 1,
        title: 'title',
        description: 'description',
        createdDate: DateTime.now(),
        isFinished: true,
      );

      when(() => mockTodoDAO.insertOrUpdate(data: newTodo)).thenAnswer((_) => Future.value());

      await todoRepository.addNewTodo(todo: newTodo);

      verify(() => mockTodoDAO.insertOrUpdate(data: newTodo)).called(1);
      verifyNoMoreInteractions(mockTodoDAO);
    });

    [true, false].asMap().forEach((index, condition) {
      test('getTodoListByCondition() case $index', () async {
        final fetchedTodos = [
          TodoModel(
            id: 1,
            title: 'title',
            description: 'description',
            createdDate: DateTime.now(),
            isFinished: true,
          ),
          TodoModel(
            id: 2,
            title: 'title-2',
            description: 'description-2',
            createdDate: DateTime.now(),
            isFinished: false,
          ),
        ];
        when(() => mockTodoDAO.getTodoListByCondition(isFinished: condition)).thenAnswer((_) => Future.value(fetchedTodos));

        final result = await todoRepository.getTodoListByCondition(isFinished: condition);

        verify(() => mockTodoDAO.getTodoListByCondition(isFinished: condition)).called(1);
        verifyNoMoreInteractions(mockTodoDAO);
        expect(result, fetchedTodos);
      });
    });
  });
}