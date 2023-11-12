import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/Todo_model.dart';
import 'package:todo_app/providers/all_providers.dart';

class TodoListItemWidget extends ConsumerStatefulWidget {
  //editlemek için yani textfield de değiştirmek için

  TodoListItemWidget({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textController;
  bool _hasFocus = false;
 

  @override
  void initState() {
    _textFocusNode = FocusNode();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final currentTodoItem = ref.watch(currentTodoProvider);
    return Focus(
      onFocusChange: (isFocused) {
        if (!isFocused) {
          setState(() {
            _hasFocus = false;
          });
          ref //bu başka yere tıkladığında bile yazdığını kaydeder
              .read(todoListProvider.notifier)
              .edit(id: currentTodoItem.id, newDescription: _textController.text);
        }
      },
      child: ListTile(
        onTap: () {
          setState(() {
            _hasFocus = true;
            _textController.text = currentTodoItem.description;
            _textFocusNode.requestFocus();
          });
        },
        leading: Checkbox(
          value: currentTodoItem.completed,
          onChanged: (value) {
            ref
                .read(todoListProvider.notifier)
                .toggle(currentTodoItem.id); //tiklemek için
          },
        ),
        title: _hasFocus
            ? TextField(
                controller: _textController,
                focusNode: _textFocusNode,
              )
            : Text(currentTodoItem.description),
      ),
    );
  }
}
