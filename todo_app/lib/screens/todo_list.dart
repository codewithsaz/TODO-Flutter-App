import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Todo List")),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['id'];
                  return Card(
                    child: ListTile(
                      leading:
                          // CircleAvatar(child: Text('${index + 1}')),
                          PopupMenuButton(
                        icon: const Icon(Icons.menu),
                        onSelected: (value) {
                          if (value == 'Edit') {
                            navigateToEditPage(item);
                          } else if (value == 'Delete') {
                            deleteById(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['task']),
                      trailing: Text(item['date']),
                    ),
                  );
                }),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add Todo')),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(id) async {
    final uri = Uri.parse("http://192.168.1.3:8080/delete-todo/$id");
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtereditems =
          items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtereditems;
      });
    } else {
      showErrorMessage("Deletion failed");
    }
  }

  Future<void> fetchTodo() async {
    final uri = Uri.parse("http://192.168.1.3:8080/todos-remaining");
    final response = await http.get(uri);
    // print(response.body);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as List;
      setState(() {
        items = result;
      });
      // final result = json[0];
    } else {
      showErrorMessage("Fetching todos failed");
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
