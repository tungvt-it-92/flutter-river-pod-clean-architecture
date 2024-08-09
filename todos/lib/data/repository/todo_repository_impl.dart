import 'package:todos/data/local/todo_dao.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoDAO _todoDAO;
  TodoRepositoryImpl(this._todoDAO);
  @override
  Future<void> addNewTodo({required TodoModel todo}) async {
    _todoDAO.insertOrUpdate(data: todo);
  }

  @override
  Future<List<TodoModel>> getAll() async {
    return _todoDAO.getAll();
  }

  @override
  Future<List<TodoModel>> getTodoListByCondition(
      {required bool isFinished}) async {
    return _todoDAO.getTodoListByCondition(isFinished: isFinished);
  }

  @override
  Future<void> updateTodo({required TodoModel todo}) {
    return _todoDAO.insertOrUpdate(data: todo);
  }

  @override
  Future<bool> remove({required int id}) {
    return _todoDAO.remove(id: id);
  }
}
