import 'package:dartz/dartz.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/domain/repository/todo_repository.dart';
import '../../core/error/failures.dart';
import 'base_usecase.dart';

abstract class GetAllTodoUseCase {
  Future<Either<Failure, List<TodoModel>>> getAll();
}

class GetAllTodoUseCaseImpl extends BaseUseCase<List<TodoModel>>
    implements GetAllTodoUseCase {
  TodoRepository todoRepository;

  GetAllTodoUseCaseImpl(
    this.todoRepository,
  );

  @override
  Future<Either<Failure, List<TodoModel>>> getAll() {
    return execute();
  }

  @override
  Future<List<TodoModel>> main() async {
    final todos = await todoRepository.getAll();
    return todos;
  }
}
