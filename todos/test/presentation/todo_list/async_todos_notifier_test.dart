import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/core/error/failures.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/usecase/index.dart';
import 'package:todos/presentation/base/base_page.dart';
import 'package:todos/presentation/page/todo_list/index.dart';

import 'async_todos_notifier_test.mocks.dart';

abstract interface class ValueChangeListener {
  call<T>(T? previousValue, T? nextValue);
}

@GenerateNiceMocks([
  MockSpec<ValueChangeListener>(),
  MockSpec<GetTodosUseCase>(),
  MockSpec<AddNewTotoUseCase>(),
  MockSpec<RemoveTodoUseCase>(),
])
main() {
  late ProviderContainer providerContainer;
  late ValueChangeListener listener;

  setUp(() {
    listener = MockValueChangeListener();
  });

  tearDown(() {
    clearInteractions(listener);
  });

  group('build', () {
    late MockGetTodosUseCase mockGetAllTodosUseCase;
    late MockGetTodosUseCase mockGetFinishedTodosUseCase;
    late MockGetTodosUseCase mockGetDoingTodosUseCase;
    final allTodos = [
      TodoModel(
        id: 1,
        title: 'all todo',
        description: 'description',
        createdDate: DateTime.now(),
        isFinished: true,
      ),
      TodoModel(
        id: 4,
        title: 'all todo 2',
        description: 'description',
        createdDate: DateTime.now(),
        isFinished: false,
      ),
    ];
    final finishedTodos = [
      TodoModel(
        id: 2,
        title: 'finished todo',
        description: 'description',
        createdDate: DateTime.now(),
        isFinished: true,
      ),
    ];
    final doingTodos = [
      TodoModel(
        id: 3,
        title: 'doing todo',
        description: 'description',
        createdDate: DateTime.now(),
        isFinished: true,
      ),
    ];
    setUp(() {
      mockGetAllTodosUseCase = MockGetTodosUseCase();
      mockGetFinishedTodosUseCase = MockGetTodosUseCase();
      mockGetDoingTodosUseCase = MockGetTodosUseCase();
      providerContainer = ProviderContainer(
        overrides: [
          getTodosUseCaseAutoDisposeFamilyProvider.overrideWith((ref, arg) {
            return arg == null
                ? mockGetAllTodosUseCase
                : (arg == true
                    ? mockGetFinishedTodosUseCase
                    : mockGetDoingTodosUseCase);
          }),
        ],
      );
      when(mockGetAllTodosUseCase())
          .thenAnswer((_) => Future.value(Right(allTodos)));
      when(mockGetDoingTodosUseCase(isFinished: false))
          .thenAnswer((_) => Future.value(Right(doingTodos)));
      when(mockGetFinishedTodosUseCase(isFinished: true))
          .thenAnswer((_) async => Right(finishedTodos));
    });

    tearDown(() {
      clearInteractions(mockGetAllTodosUseCase);
      clearInteractions(mockGetFinishedTodosUseCase);
      clearInteractions(mockGetDoingTodosUseCase);
    });

    test('should initialize with all todos', () async {
      providerContainer.listen(
        asyncTodosAutoDisposeFamilyProvider(PageTag.allTodo),
        listener.call,
        fireImmediately: true,
      );

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.allTodo).future);
      await Future.delayed(const Duration(milliseconds: 0));

      verify(mockGetAllTodosUseCase()).called(1);
      verifyNoMoreInteractions(mockGetAllTodosUseCase);
      verifyNever(mockGetDoingTodosUseCase(isFinished: false));
      verifyNever(mockGetFinishedTodosUseCase(isFinished: true));

      verify(
        listener.call(
          null,
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
        ),
      );

      verify(
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.todos, 'todos', allTodos),
        ),
      );
    });

    test('should initialize with doing todos', () async {
      providerContainer.listen(
        asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo),
        listener.call,
        fireImmediately: true,
      );

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo).future);
      await Future.delayed(const Duration(milliseconds: 0));

      verify(mockGetDoingTodosUseCase(isFinished: false)).called(1);
      verifyNoMoreInteractions(mockGetDoingTodosUseCase);
      verifyNever(mockGetAllTodosUseCase());
      verifyNever(mockGetFinishedTodosUseCase(isFinished: true));
      verifyInOrder([
        listener.call(
          null,
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
        ),
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.todos, 'todos', doingTodos),
        ),
      ]);
    });

    test('should initialize with finished todos', () async {
      providerContainer.listen(
        asyncTodosAutoDisposeFamilyProvider(PageTag.doneTodo),
        listener.call,
        fireImmediately: true,
      );

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.doneTodo).future);
      await Future.delayed(const Duration(milliseconds: 0));

      verify(mockGetFinishedTodosUseCase(isFinished: true)).called(1);
      verifyNoMoreInteractions(mockGetFinishedTodosUseCase);
      verifyNever(mockGetAllTodosUseCase());
      verifyNever(mockGetDoingTodosUseCase(isFinished: false));

      verifyInOrder([
        listener.call(
          null,
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
        ),
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.todos, 'todos', finishedTodos),
        ),
      ]);
    });
  });

  group('add()', () {
    late AddNewTotoUseCase mockAddNewTotoUseCase;
    final newTodo = TodoModel(
      id: 1,
      title: 'new todo',
      description: 'description',
      createdDate: DateTime.now(),
      isFinished: false,
    );

    setUp(() {
      mockAddNewTotoUseCase = MockAddNewTotoUseCase();
      providerContainer = ProviderContainer(
        overrides: [
          addNewTodoProviderUseCaseProvider
              .overrideWithValue(mockAddNewTotoUseCase),
        ],
      );
      providerContainer.listen(
        asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo),
        listener.call,
        fireImmediately: false,
      );
    });

    test('should add new todo', () async {
      when(mockAddNewTotoUseCase(todoModel: newTodo))
          .thenAnswer((_) => Future.value(const Right(true)));

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo).notifier)
          .add(todo: newTodo);

      verify(mockAddNewTotoUseCase(todoModel: newTodo)).called(1);
      verify(
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', []),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.todos, 'todos', [newTodo]),
        ),
      );
    });

    test('should handle failure', () async {
      final failure = RemoteFailure(
        msg: 'add todo error message',
        errorCode: 'error-code',
        data: 'data',
      );
      when(mockAddNewTotoUseCase(todoModel: newTodo))
          .thenAnswer((_) => Future.value(Left(failure)));

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo).notifier)
          .add(todo: newTodo);

      verify(mockAddNewTotoUseCase(todoModel: newTodo)).called(1);
      verify(
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.failure, 'failure', null)
              .having((p) => p.value.todos, 'todos', []),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.failure, 'failure', failure)
              .having((p) => p.value.todos, 'todos', []),
        ),
      );
    });
  });

  group('remove()', () {
    late RemoveTodoUseCase mockRemoveTodoUseCase;
    late GetTodosUseCase mockGetDoingTodosUseCase;
    final removeTodo = TodoModel(
      id: 1,
      title: 'new todo',
      description: 'description',
      createdDate: DateTime.now(),
      isFinished: false,
    );

    setUp(() async {
      mockRemoveTodoUseCase = MockRemoveTodoUseCase();
      mockGetDoingTodosUseCase = MockGetTodosUseCase();
      providerContainer = ProviderContainer(
        overrides: [
          removeTodoUseCaseAutoDisposeProvider
              .overrideWithValue(mockRemoveTodoUseCase),
          getTodosUseCaseAutoDisposeFamilyProvider
              .overrideWith((_, __) => mockGetDoingTodosUseCase),
        ],
      );
      when(mockGetDoingTodosUseCase(isFinished: false))
          .thenAnswer((_) => Future.value(Right([removeTodo])));
      providerContainer.listen(
        asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo),
        listener.call,
        fireImmediately: true,
      );
      await Future.delayed(const Duration(seconds: 0));
    });

    test('should remove todo', () async {
      when(mockRemoveTodoUseCase(todoModel: removeTodo))
          .thenAnswer((_) => Future.value(const Right(true)));

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo).notifier)
          .remove(todo: removeTodo);

      verify(mockRemoveTodoUseCase(todoModel: removeTodo)).called(1);
      verify(
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', [removeTodo]),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.todos, 'todos', []),
        ),
      );
    });

    test('should handle failure', () async {
      final failure = RemoteFailure(
        msg: 'remove todo error message',
        errorCode: 'error-code',
        data: 'data',
      );
      when(mockRemoveTodoUseCase(todoModel: removeTodo))
          .thenAnswer((_) => Future.value(Left(failure)));

      await providerContainer
          .read(asyncTodosAutoDisposeFamilyProvider(PageTag.doingTodo).notifier)
          .remove(todo: removeTodo);

      verify(mockRemoveTodoUseCase(todoModel: removeTodo)).called(1);
      verify(
        listener.call(
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', true)
              .having((p) => p.value.todos, 'todos', [removeTodo]),
          isA<AsyncData<TodosState>>()
              .having((p) => p.value.isLoading, 'isLoading', false)
              .having((p) => p.value.failure, 'failure', failure)
              .having((p) => p.value.todos, 'todos', [removeTodo]),
        ),
      );
    });
  });
}
