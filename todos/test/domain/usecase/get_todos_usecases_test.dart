import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/core/error/failures.dart';
import 'package:todos/data/repository/index.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import 'package:todos/domain/usecase/get_todos_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

main() {
  late GetTodosUseCase getTodosUseCase;
  late MockTodoRepository mockTodoRepository;
  late ProviderContainer providerContainer;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    providerContainer = ProviderContainer(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockTodoRepository),
      ],
    );
    getTodosUseCase =
        providerContainer.read(getTodosUseCaseAutoDisposeFamilyProvider(null));
  });

  tearDown(() {
    reset(mockTodoRepository);
  });

  group('GetTodosUseCase', () {
    test('should return all todo when not providing condition', () async {
      final allTodos = [
        TodoModel(
          id: 1,
          title: 'title',
          description: 'description',
          createdDate: DateTime.now(),
          isFinished: true,
        ),
      ];
      when(() => mockTodoRepository.getAll())
          .thenAnswer((_) => Future.value(allTodos));

      Either<Failure, List<TodoModel>> result = await getTodosUseCase();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), allTodos);
      verify(() => mockTodoRepository.getAll()).called(1);
      verifyNoMoreInteractions(mockTodoRepository);
      verifyNever(
        () => mockTodoRepository.getTodoListByCondition(isFinished: true),
      );
      verifyNever(
        () => mockTodoRepository.getTodoListByCondition(isFinished: false),
      );
    });

    [true, false].asMap().forEach((index, condition) {
      test('should return filtered todos when providing condition case $index',
          () async {
        final filteredTodos = [
          TodoModel(
            id: 1,
            title: 'title',
            description: 'description',
            createdDate: DateTime.now(),
            isFinished: true,
          ),
        ];
        when(
          () => mockTodoRepository.getTodoListByCondition(
            isFinished: condition,
          ),
        ).thenAnswer((_) => Future.value(filteredTodos));

        Either<Failure, List<TodoModel>> result =
            await getTodosUseCase(isFinished: condition);

        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), filteredTodos);
        verify(
          () => mockTodoRepository.getTodoListByCondition(
            isFinished: condition,
          ),
        ).called(1);
        verifyNever(() => mockTodoRepository.getAll());
        verifyNoMoreInteractions(mockTodoRepository);
      });
    });
  });
}
