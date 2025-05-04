import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/crud_todo.dart';
import 'package:todoapp/models/todo.dart';

class CreateTodo extends StatefulWidget {
  final DateTime selectedDay;

  const CreateTodo({Key? key, required this.selectedDay}): super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _formKey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var showError= false;
  var title = '';
  var remindme = false;
  @override
  Widget build(BuildContext context) {
   return BackdropFilter(
       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Text(
                    'Create Todo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  SizedBox(height: 18.h),
                  TextFormField(
                    maxLines: 2,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.task),
                      label: Text('Title'),
                    ),
                    autocorrect: false,
                    onChanged: (value) {
                      title = value;
                      if(showError) {
                        setState(() {
                          showError = false;
                        });
                      }
                    },
                    validator: (value) {
                      if(value != null && value.length <= 4) {
                        return "Title is too short";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18.h),
                  SwitchListTile(
                      value: remindme,
                      onChanged: (bool newValue) {
                        setState(() {
                          remindme = newValue;
                        });
                      }
                  ),
                  SizedBox(height: 18.h),
                  TextButton(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      )
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        final crudTodo = Provider.of<CrudTodo>(context, listen: false);
                        final todo = Todo(createdAt: widget.selectedDay.toUtc(),  title: title, isReminder: remindme, isDone: true);
                        crudTodo.putTaskItemsToServer(todo);
                        _showNotification(todo);
                        Navigator.pop(context);
                      }
                      else {
                        setState(() {
                          showError = true;
                        });
                      }
                    },
                  )
                ]
              )
          ),
        ),
   );
  }
  Future<void> _showNotification(Todo todo) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('todo-channel', 'Todo Notifications',
        channelDescription: 'Show notification when created',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      0,
      todo.title,
      'Todo created',
      platformChannelSpecifics,
      payload: todo.toJson().toString(),
    );
  }
}