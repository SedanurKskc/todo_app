import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/Todo_model.dart';
import 'package:todo_app/providers/todo_list_manager.dart';
import 'package:uuid/uuid.dart';

enum TodoListFilter { all, active, completed }

final todoListFilter =
    StateProvider<TodoListFilter>((ref) => TodoListFilter.all);
final todoListProvider =
    StateNotifierProvider<TodoListManager, List<TodoModel>>(
        (ref) => TodoListManager([
              TodoModel(id: Uuid().v4(), description: "Spora Git"),
              TodoModel(id: Uuid().v4(), description: "Ders Çalış"),
              TodoModel(id: Uuid().v4(), description: "Alışveriş Yap"),
              TodoModel(id: Uuid().v4(), description: "TV İzle"),
            ]));

final filteredTodoList = Provider<List<TodoModel>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todoList = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.all:
      return todoList;

    case TodoListFilter.completed:
      return todoList.where((element) => element.completed).toList();
    case TodoListFilter.active:
      return todoList.where((element) => !element.completed).toList();
  }
});

final unCompletedTodoCount = Provider((ref) {
  final allTodo = ref.watch(todoListProvider);
  final count = allTodo.where((element) => !element.completed).length;
  return count; //eğer sayı değişmiyorsa dinleyen build toolbar widget tetiklenmez
});

final currentTodoProvider = Provider<TodoModel>((ref) {
  throw UnsupportedError("HATA");
});
