import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/Todo_model.dart';
import 'package:todo_app/providers/all_providers.dart';
import 'package:todo_app/widget/FutureProviderExample.dart';
import 'package:todo_app/widget/Todo_list_item.dart';
import 'package:todo_app/widget/title_widget.dart';
import 'package:todo_app/widget/toolbar_widget.dart';
import 'package:uuid/uuid.dart';

class ToDoApp extends ConsumerWidget {
  final newTodoController = TextEditingController();

  ToDoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allTodos = ref.watch(filteredTodoList);
    return Scaffold(
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            TitleWidget(),
            TextField(
              controller: newTodoController,
              decoration: InputDecoration(
                labelText: "Neler yapacaksın bugün ? ",
              ),
              onSubmitted: (newTodo) {
                //yeni görev eklenir.
                ref.read(todoListProvider.notifier).addTodo(newTodo);
              },
            ),
            SizedBox(
              height: 20,
            ),
            ToolBarWidget(),
            allTodos.length == 0
                ? Center(child: Text("Bu koşullarda herhangi bir görev yok."))
                : SizedBox(),
            for (var i = 0; i < allTodos.length; i++)
              Dismissible(
                  //kaydırınca silinir.
                  key: ValueKey(allTodos[i].id),
                  onDismissed: (direction) {
                    ref.read(todoListProvider.notifier).remove(allTodos[i]);
                  },
                  child: ProviderScope(overrides: [
                    currentTodoProvider.overrideWithValue(allTodos[i])
                  ], child: TodoListItemWidget())),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FutureProviderExample(),
                    ));
                    
              },
              child: Text("Future Provider Example"),
            ),
          ]),
    );
  }
}
