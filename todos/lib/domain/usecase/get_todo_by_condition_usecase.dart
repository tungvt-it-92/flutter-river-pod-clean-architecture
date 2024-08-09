import 'package:dartz/dartz.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import 'base_usecase.dart';

abstract class GetTodoListByConditionUseCase {
  Future<Either<Failure, List<TodoModel>>> getTodoListByCondition(
      {required bool isFinished});
}

class GetTodoListByConditionUseCaseImpl extends BaseUseCase<List<TodoModel>>
    implements GetTodoListByConditionUseCase {
  TodoRepository todoRepository;
  bool _isFinished = false;

  GetTodoListByConditionUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, List<TodoModel>>> getTodoListByCondition(
      {required bool isFinished}) {
    _isFinished = isFinished;
    return execute();
  }

  @override
  Future<List<TodoModel>> main() async {
    final todos =
        await todoRepository.getTodoListByCondition(isFinished: _isFinished);
    return todos;
  }
}
