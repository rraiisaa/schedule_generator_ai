import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class AddTaskListSection extends StatefulWidget {
  final Function(Task) onAddTask; // buat nampung function yang di pass dari home screen untuk nambahin task ke list
  const AddTaskListSection({super.key, required this.onAddTask});

  @override
  State<AddTaskListSection> createState() => _AddTaskListSectionState();
}

class _AddTaskListSectionState extends State<AddTaskListSection> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}