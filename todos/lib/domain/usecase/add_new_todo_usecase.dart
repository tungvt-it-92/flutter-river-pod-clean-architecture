import 'package:dartz/dartz.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import 'base_usecase.dart';

abstract class AddNewTotoUseCase {
  Future<Either<Failure, bool>> addNewTodo({required TodoModel todoModel});
}

class AddNewTotoUseCaseImpl extends BaseUseCase<bool>
    implements AddNewTotoUseCase {
  TodoRepository todoRepository;
  late TodoModel _todoModel;

  AddNewTotoUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, bool>> addNewTodo(
      {required TodoModel todoModel}) async {
    _todoModel = todoModel;
    return execute();
  }

  @override
  Future<bool> main() async {
    await todoRepository.addNewTodo(todo: _todoModel);
    return true;
  }
}
