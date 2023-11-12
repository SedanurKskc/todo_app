import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/Todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? initialTodos]) : super(initialTodos ?? []);

  void addTodo(String description) {
    var eklenecekTodo = TodoModel(id: Uuid().v4(), description: description);
    state = [...state, eklenecekTodo]; //eski stateleri koy yeni gelenleri ekle
  }

  void toggle(String id) {
    //tamamlanmışı tamamlanmamışa çekmek ya da tam tersi
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed)
        else
          todo
    ];
  }

  void edit({required String id, required String newDescription}) {
    //değiştirilmek istenenin idsi ve yanı tanımı lazım...
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              completed: todo.completed,
              description: newDescription)
        else
          todo
    ];
  }

  void remove(TodoModel silinecekTodo) {
    //idsi aynı olmayanlalrı yeni state yaz aynı olanı sil
    state = state.where((element) => element.id != silinecekTodo.id).toList();
  }

  int onCompletedTodoCount() {//tamamlanmamış görevlerin sayısını döndürür.
    return state.where((element) => !element.completed).length;
  }
}
