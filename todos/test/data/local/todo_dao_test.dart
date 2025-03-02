import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// import 'package:mocktail/mocktail.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/data/local/index.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/objectbox.g.dart';

import 'todo_dao_test.mocks.dart';

// ignore_for_file: lines_longer_than_80_chars
/*
* Manually create mock object by using mocktail
*/

// class MockStoreProvider extends Mock implements StoreProvider {}
// class MockStore extends Mock implements Store {}
// class MockBox extends Mock implements Box<TodoModel> {}
// class MockBuilder extends Mock implements  QueryBuilder<TodoModel> {}
// class MockQuery extends Mock implements Query<TodoModel> {}

// main() {
//   late TodoDAOImpl todoDAOImpl;
//   late StoreProvider mockStoreProvider;
//   late Store mockStore;
//   late Box<TodoModel> mockBox;
//
//
//   setUpAll(() {
//     mockStoreProvider = MockStoreProvider();
//     mockStore = MockStore();
//     mockBox = MockBox();
//     when(() => mockStoreProvider.getStore()).thenAnswer((_) => Future.value(mockStore));
//     when(() => mockStore.box<TodoModel>()).thenReturn(mockBox);
//     todoDAOImpl = TodoDAOImpl(storeProvider: mockStoreProvider);
//   });
//
//   group('getAll()', () {
//     late QueryBuilder<TodoModel> mockQueryBuilder;
//     late Query<TodoModel> mockQuery;
//
//     final allTodos = [
//       TodoModel(
//         id: 0,
//         title: "todo0",
//         description: "description0",
//         createdDate: DateTime.now(),
//         isFinished: true,
//       ),
//       TodoModel(
//         id: 1,
//         title: "todo1",
//         description: "description1",
//         createdDate: DateTime.now(),
//         isFinished: true,
//       )
//     ];
//     setUp(() {
//       mockQueryBuilder = MockBuilder();
//       mockQuery = MockQuery();
//       when(() => mockBox.query()).thenReturn(mockQueryBuilder);
//       when(() => mockQueryBuilder.order(TodoModel_.createdDate, flags: Order.descending)).thenReturn(mockQueryBuilder);
//       when(() => mockQueryBuilder.build()).thenReturn(mockQuery);
//       when(() => mockQuery.find()).thenReturn(allTodos);
//       when(() => mockQuery.close()).thenAnswer((_) => {});
//     });
//
//     test('should get all todo list', () async {
//       final result = await todoDAOImpl.getAll();
//
//       verify(() => mockStoreProvider.getStore()).called(1);
//       verify(() => mockStore.box<TodoModel>()).called(1);
//       verify(() => mockBox.query()).called(1);
//       verify(() => mockQueryBuilder.order(TodoModel_.createdDate, flags: Order.descending)).called(1);
//       verify(() => mockQueryBuilder.build()).called(1);
//       verify(() => mockQuery.find()).called(1);
//       verify(() => mockQuery.close()).called(1);
//       expect(result, equals(allTodos));
//     });
//   });
//
// }

/*
* Auto generate mocks object by mocktail
*  */

@GenerateNiceMocks([
  MockSpec<StoreProvider>(),
  MockSpec<Store>(),
  MockSpec<Box<TodoModel>>(),
  MockSpec<QueryBuilder<TodoModel>>(
    unsupportedMembers: {
      Symbol('link'),
      Symbol('backlink'),
      Symbol('linkMany'),
      Symbol('backlinkMany'),
    },
  ),
  MockSpec<Query<TodoModel>>(),
])
main() {
  late TodoDAOImpl todoDAOImpl;
  late StoreProvider mockStoreProvider;
  late Store mockStore;
  late Box<TodoModel> mockBox;

  setUpAll(() {
    mockStoreProvider = MockStoreProvider();
    mockStore = MockStore();
    mockBox = MockBox();
    when(mockStoreProvider.getStore())
        .thenAnswer((_) => Future.value(mockStore));
    when(mockStore.box<TodoModel>()).thenReturn(mockBox);
    todoDAOImpl = TodoDAOImpl(storeProvider: mockStoreProvider);
  });

  group('getAll()', () {
    late QueryBuilder<TodoModel> mockQueryBuilder;
    late Query<TodoModel> mockQuery;

    final allTodos = [
      TodoModel(
        id: 0,
        title: 'todo0',
        description: 'description0',
        createdDate: DateTime.now(),
        isFinished: true,
      ),
      TodoModel(
        id: 1,
        title: 'todo1',
        description: 'description1',
        createdDate: DateTime.now(),
        isFinished: true,
      ),
    ];
    setUp(() {
      mockQueryBuilder = MockQueryBuilder();
      mockQuery = MockQuery();
      when(mockBox.query()).thenReturn(mockQueryBuilder);
      when(
        mockQueryBuilder.order(
          TodoModel_.createdDate,
          flags: Order.descending,
        ),
      ).thenReturn(mockQueryBuilder);
      when(mockQueryBuilder.build()).thenReturn(mockQuery);
      when(mockQuery.find()).thenReturn(allTodos);
      when(mockQuery.close()).thenAnswer((_) => {});
    });

    test('should get all todo list', () async {
      final result = await todoDAOImpl.getAll();

      verify(mockStoreProvider.getStore()).called(1);
      verify(mockStore.box<TodoModel>()).called(1);
      verify(mockBox.query()).called(1);
      verify(
        mockQueryBuilder.order(
          TodoModel_.createdDate,
          flags: Order.descending,
        ),
      ).called(1);
      verify(mockQueryBuilder.build()).called(1);
      verify(mockQuery.find()).called(1);
      verify(mockQuery.close()).called(1);
      expect(result, equals(allTodos));
    });
  });
}
