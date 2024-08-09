import 'package:dartz/dartz.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import 'base_usecase.dart';

abstract class UpdateTodoUseCase {
  Future<Either<Failure, bool>> updateTodo({required TodoModel todoModel});
}

class UpdateTodoUseCaseImpl extends BaseUseCase<bool>
    implements UpdateTodoUseCase {
  TodoRepository todoRepository;
  late TodoModel _todoModel;

  UpdateTodoUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, bool>> updateTodo(
      {required TodoModel todoModel}) async {
    _todoModel = todoModel;
    return execute();
  }

  @override
  Future<bool> main() async {
    await todoRepository.updateTodo(todo: _todoModel);
    return true;
  }
}
