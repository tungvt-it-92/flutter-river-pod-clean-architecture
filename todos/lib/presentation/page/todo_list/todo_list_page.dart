import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/presentation/base/base_page_mixin.dart';

import '../../base/base_page.dart';
import '../../widgets/index.dart';
import 'async_todos_provider.dart';
import 'widget/todo_item_widget.dart';

class TodoListPage extends BasePage {
  const TodoListPage({required PageTag pageTag, super.key}) : super(tag: pageTag);

  @override
  State<StatefulWidget> createState() => TodoListPageState();
}

class TodoListPageState extends BasePageState<TodoListPage> with BasePageMixin {
  final RefreshController _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildLayout(BuildContext context, WidgetRef ref) {
    final pageTag = (widget as BasePage).tag;
    final AsyncValue<List<TodoModel>> state = ref.watch(asyncTodosAutoDisposeProvider(pageTag));
    _controller.refreshCompleted();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SmartRefresher(
        onRefresh: () {
          ref.refresh(asyncTodosAutoDisposeProvider(pageTag).notifier);
        },
        controller: _controller,
        child: switch (state) {
          AsyncError() => const Text('Oops, something unexpected happened'),
          AsyncData(:final value) => value.isEmpty
              ? const NoDataMessageWidget()
              : ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
                  itemCount: value.length,
                  itemBuilder: (_, index) {
                    return TodoItemWidget(
                      onUpdateClicked: (todo) {
                        _showUpdateConfirmDialog(todo, ref, pageTag);
                      },
                      todo: value[index],
                      onConfirmDismiss: (c, todo) {
                        _showDeleteConfirmDialog(todo, ref, pageTag);
                      },
                    );
                  },
                ),
          _ => buildShimmer(),
        },
      ),
    );
  }

  _showUpdateConfirmDialog(TodoModel todo, WidgetRef ref, PageTag tag) async {
    final message = todo.isFinished ? 'Mark this item is "Doing" ?' : 'Mark this item is "Done" ?';
    final isOk = await showAlert(context: context, message: message);
    if (isOk) {
      todo.isFinished = !todo.isFinished;
      ref.read(asyncTodosAutoDisposeProvider(tag).notifier).updateTodo(todo: todo);
    }
  }

  _showDeleteConfirmDialog(TodoModel todo, WidgetRef ref, PageTag tag) async {
    final isOk = await showAlert(
      context: context,
      message: 'Are you sure to delete this note?',
      okActionTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (isOk) {
      ref.read(asyncTodosAutoDisposeProvider(tag).notifier).remove(todo: todo);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
