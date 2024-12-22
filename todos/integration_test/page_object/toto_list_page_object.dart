import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos/presentation/page/todo_list/widget/todo_item_widget.dart';

import 'base_page_object.dart';

class TodoListPageObject extends BasePageObject {

  TodoListPageObject({
    required super.tester,
  });

  final _addTodoButton = find.byType(FloatingActionButton);
  final _titleTextField = find.byType(TextFormField).first;
  final _descriptionTextField = find.byType(TextFormField).last;
  final _saveButton = find.text('Save');

  clickOnAddNewTodoButton() async {
    await click(_addTodoButton);
  }

  enterTodoTitle(String title) async {
    await enterText(_titleTextField, title);
  }

  enterTodoDescription(String description) async {
    await enterText(_descriptionTextField, description);
  }

  clickOnSaveButton() async {
    await click(_saveButton);
  }

  clickOnMarkAsDoneButton({ required int atItemIndex }) async {
    final markAsDoneButton = find.descendant(of: find.byType(TodoItemWidget), matching:find.byKey(const ValueKey('updateTodoItem')));
    await click(markAsDoneButton);
  }

  changeTab({required String tabName}) async {
    await clickOnButtonText(buttonName: tabName);
  }
}