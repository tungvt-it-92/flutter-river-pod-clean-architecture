import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos/data/repository/repository_provider.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import 'package:todos/domain/usecase/index.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

main() {
  late AddNewTotoUseCase addNewTotoUseCase;
  late MockTodoRepository mockTodoRepository;
  late ProviderContainer providerContainer;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    providerContainer = ProviderContainer(
        overrides: [
          todoRepositoryProvider.overrideWithValue(mockTodoRepository)
        ]
    );
    addNewTotoUseCase = providerContainer.read(addNewTodoProviderUseCaseProvider);
  });

  tearDown(() {
    reset(mockTodoRepository);
  });

  group('AddNewTotoUseCase', () {
    test('should add new todo successfully', () async {
      final newTodo = TodoModel(
        id: 1,
        title: 'title',
        description: 'description',
        createdDate: DateTime.now(),
        isFinished: true,
      );
      when(() => mockTodoRepository.addNewTodo(todo: newTodo)).thenAnswer((_) => Future.value());


      final result = await addNewTotoUseCase(todoModel: newTodo);

      verify(() => mockTodoRepository.addNewTodo(todo: newTodo)).called(1);
      verifyNoMoreInteractions(mockTodoRepository);
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), true);
    });
  });
}