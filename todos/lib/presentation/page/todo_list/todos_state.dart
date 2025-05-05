import 'package:todos/core/error/failures.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todos_state.freezed.dart';

@freezed
class TodosState with _$TodosState {

  factory TodosState({
    @Default([]) List<TodoModel> todos,
    @Default(false) bool isLoading,
    Failure? failure,
  }) = _TodosState;
}