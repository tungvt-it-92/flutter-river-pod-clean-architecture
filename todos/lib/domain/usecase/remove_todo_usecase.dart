import 'package:dartz/dartz.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import 'base_usecase.dart';

abstract class RemoveTodoUseCase {
  Future<Either<Failure, bool>> removeTodo({required TodoModel todoModel});
}

class RemoveTodoUseCaseImpl extends BaseUseCase<bool>
    implements RemoveTodoUseCase {
  TodoRepository todoRepository;
  late TodoModel _todoModel;

  RemoveTodoUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, bool>> removeTodo(
      {required TodoModel todoModel}) async {
    _todoModel = todoModel;
    return execute();
  }

  @override
  Future<bool> main() async {
    await todoRepository.remove(id: _todoModel.id);
    return true;
  }
}
