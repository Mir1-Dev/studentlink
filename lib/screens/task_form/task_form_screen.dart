import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../../services/task_repository.dart';
import '../../widgets/app_logo.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});

  final Task? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _subjectController = TextEditingController(text: task?.subject ?? '');
    _selectedDate = task?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final task = (widget.task ?? Task(
      title: '',
      subject: '',
      dueDate: _selectedDate,
    )).copyWith(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      subject: _subjectController.text.trim(),
      dueDate: _selectedDate,
    );

    final navigator = Navigator.of(context);

    if (widget.task == null) {
      await TaskRepository.instance.addTask(task);
    } else {
      await TaskRepository.instance.updateTask(task);
    }

    if (mounted) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        leading: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: AppLogo(size: 24),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Enter a subject' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due date',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        const Icon(Icons.calendar_today_rounded),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: Text(isEditing ? 'Update Task' : 'Save Task'),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await TaskRepository.instance.deleteTask(widget.task!);
                      if (mounted) navigator.pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete Task'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
