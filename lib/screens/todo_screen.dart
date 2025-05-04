import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/crud_todo.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/widgets/calendar_widget.dart';

import '../widgets/buy_premium.dart';
import '../widgets/create_todo.dart';
import '../widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    final DateTime curr = DateTime.now();
    selectedDay = DateTime(curr.year, curr.month, curr.day);
    Provider.of<List<PurchaseDetails>?>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<List<Todo>>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const BuyPremium();
                    });
              },
              icon: const Icon(Icons.attach_money)),
          IconButton(
              onPressed: () async {
                await _deleteAppDir();
                await _deleteCacheDir();
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CalendarWidget(
                initialDaySelected: DateTime.now(),
                changeDay: (DateTime day) {
                  setState(() {
                    selectedDay = DateTime(day.year, day.month, day.day);
                  });
                },
              )),
          Expanded(
            child: Consumer<CrudTodo>(
              builder: (context, crudTodo, _) {
                final Map<DateTime, List<Todo>> taskItemsMap =
                    crudTodo.taskItemsMap;
                final List<Todo> todoList = taskItemsMap[selectedDay] ?? [];
                return ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return TodoTile(todo: todoList[index]);
                    });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateTodo(selectedDay: selectedDay);
          }
        );
      }),
    );
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }
}
