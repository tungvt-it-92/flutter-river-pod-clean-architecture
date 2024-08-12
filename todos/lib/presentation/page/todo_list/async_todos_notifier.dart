import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/presentation/base/base_page.dart';
import 'package:todos/presentation/page/todo_list/async_todos_provider.dart';

import '../../../data/repository/index.dart';

class AsyncTodosAutoDisposeFamilyAsyncNotifier extends AutoDisposeFamilyAsyncNotifier<List<TodoModel>, PageTag> {
  @override
  Future<List<TodoModel>> build(PageTag arg) {
    final todoRepository = ref.read(totoRepositoryProvider);
    if (arg == PageTag.allTodo) {
      return todoRepository.getAll();
    }
    if (arg == PageTag.doingTodo) {
      return todoRepository.getTodoListByCondition(isFinished: false);
    }

    return todoRepository.getTodoListByCondition(isFinished: true);
  }

  add({required TodoModel todo}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todoRepository = ref.read(totoRepositoryProvider);
      await todoRepository.addNewTodo(todo: todo);
      var current = state.value ?? [];
      current.add(todo);
      return current;
    });
  }

  remove({required TodoModel todo}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todoRepository = ref.read(totoRepositoryProvider);
      await todoRepository.remove(id: todo.id);
      var current = state.value ?? [];
      current.remove(todo);
      return current;
    });
  }

  updateTodo({required TodoModel todo, required PageTag tag}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todoRepository = ref.read(totoRepositoryProvider);
      await todoRepository.updateTodo(todo: todo);
      var current = state.value ?? [];
      final index = current.indexOf(todo);
      if (index >= 0 && tag == PageTag.allTodo) {
        current[index] = todo;
      } else {
       current.removeAt(index);
      }
      return current;
    });
  }
}

// TODO: try with regular AsyncNotifier
class AsyncTodosNotifier extends AsyncNotifier<List<TodoModel>> {
  @override
  Future<List<TodoModel>> build() async {
    final tag = ref.watch(todoFilterConditionProvider);
    final todoRepository = ref.read(totoRepositoryProvider);
    if (tag == PageTag.allTodo) {
      return todoRepository.getAll();
    }
    if (tag == PageTag.doingTodo) {
      return todoRepository.getTodoListByCondition(isFinished: false);
    }

    return todoRepository.getTodoListByCondition(isFinished: true);
  }

  add({required TodoModel todo}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todoRepository = ref.read(totoRepositoryProvider);
      await todoRepository.addNewTodo(todo: todo);
      var current = state.value ?? [];
      current.add(todo);
      return current;
    });
  }

  remove({required TodoModel todo}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todoRepository = ref.read(totoRepositoryProvider);
      await todoRepository.remove(id: todo.id);
      var current = state.value ?? [];
      current.remove(todo);
      return current;
    });
  }

  updateTodo({required TodoModel todo}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final todoRepository = ref.read(totoRepositoryProvider);
      await todoRepository.updateTodo(todo: todo);
      var current = state.value ?? [];
      final index = current.indexOf(todo);
      if (index >= 0) {
        current[index] = todo;
      }
      return current;
    });
  }
}
