import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      key: ValueKey(todo.id),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: Slidable(
          key: ValueKey(todo.id),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(onPressed: (context) {
                todo.isDone = true;
              },
                backgroundColor: Colors.lightGreen.shade300,
                foregroundColor: Colors.white,
                icon: Icons.done,
                label: 'Done',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  // Handle delete action
                },
                backgroundColor: Colors.red.shade300,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              )
            ]
          ),
          child: ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: const Icon(Icons.task),
            trailing: todo.isReminder ? const Icon(Icons.notifications_active) : null,
          )
      ),
    );
  }
}