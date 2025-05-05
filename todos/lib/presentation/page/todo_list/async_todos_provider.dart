import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/presentation/page/todo_list/async_todos_notifier.dart';
import 'package:todos/presentation/page/todo_list/todos_state.dart';

import '../../utils/page_tag.dart';

final asyncTodosAutoDisposeFamilyProvider =
    AutoDisposeAsyncNotifierProviderFamily<
        AsyncTodosAutoDisposeFamilyAsyncNotifier,
        TodosState,
        PageTag
    >(AsyncTodosAutoDisposeFamilyAsyncNotifier.new);

/*
* Use regular AsyncNotifierProvider
*/

// final asyncTodosProvider =
//     AsyncNotifierProvider<AsyncTodosNotifier, List<TodoModel>>(() {
//   return AsyncTodosNotifier();
// });

// final asyncTodosProvider =
// AsyncNotifierProvider<AsyncTodosNotifier, List<TodoModel>>(AsyncTodosNotifier.new);
//
// final todoFilterConditionProvider = StateProvider<PageTag>((ref) {
//   return PageTag.allTodo;
// });
