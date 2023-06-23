import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  String selectedDate = DateTime.now().toString();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final task = todo['task'];
      final date = todo['date'];
      titleController.text = title;
      taskController.text = task;
      selectedDate = date;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Task'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(selectedDate.split(' ')[0]),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select date'),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['id'];
    final title = titleController.text;
    final task = taskController.text;
    final date = selectedDate.toString().split(' ')[0];

    final body = {
      'title': title,
      'task': task,
      'date': date,
      'completed': 0,
    };
    final uri = Uri.parse("http://192.168.1.3:8080/update-todo/$id");
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      showSuccessMessage("Todo updated");
    } else {
      showErrorMessage("Todo not updated");
    }
  }

  Future<void> submitData() async {
    //Get Data

    final title = titleController.text;
    final task = taskController.text;
    final date = selectedDate.toString().split(' ')[0];

    final body = {
      'title': title,
      'task': task,
      'date': date,
      'completed': 0,
    };

    //submit Data
    final uri = Uri.parse("http://192.168.1.3:8080/add-todo");
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      showSuccessMessage("Todo created");
      Navigator.pop(context);
    } else {
      showErrorMessage("Todo not created");
    }
    //Visual Feedback
  }

  void showSuccessMessage(String message) {
    taskController.text = '';
    titleController.text = '';
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
