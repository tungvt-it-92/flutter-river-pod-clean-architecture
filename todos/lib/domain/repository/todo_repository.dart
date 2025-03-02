import 'package:todos/domain/model/todo_model.dart';

abstract class TodoRepository {
  Future<void> addNewTodo({required TodoModel todo});
  Future<void> updateTodo({required TodoModel todo});
  Future<List<TodoModel>> getAll();
  Future<List<TodoModel>> getTodoListByCondition({required bool isFinished});
  Future<bool> remove({required int id});
}
