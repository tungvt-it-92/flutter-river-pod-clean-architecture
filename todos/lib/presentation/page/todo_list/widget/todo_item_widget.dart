import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todos/core/utils/index.dart';
import 'package:todos/domain/model/todo_model.dart';
import 'package:todos/presentation/widgets/round_container.dart';

import '../../../styles/index.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final Function(TodoModel) onUpdateClicked;
  final Function(BuildContext, TodoModel)? onConfirmDismiss;

  const TodoItemWidget({
    required this.onUpdateClicked,
    required this.todo,
    this.onConfirmDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(todo.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dragDismissible: false,
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (c) {
              if (onConfirmDismiss != null) {
                onConfirmDismiss!(c, todo);
              }
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: RoundContainer(
        allRadius: 15,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      todo.description,
                      style: bodySmall,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      todo.createdDate.formatDateAndTime(),
                      style: bodySmall.copyWith(
                          color: AppColors.gray[400],
                          fontSize: 11,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const ValueKey('updateTodoItem'),
                  onPressed: () {
                    onUpdateClicked(todo);
                  },
                  icon: Icon(
                    todo.isFinished ? Icons.done : Icons.radio_button_unchecked,
                    color: AppColors.primaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
