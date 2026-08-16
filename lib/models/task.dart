class Task {
  // The database automatically creates the ID for a new task.
  final int? id;

  // Information entered by the user.
  final String title;
  final String subject;
  final DateTime dueDate;

  // False means pending and true means completed.
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Converts a Task object into values that SQLite can store.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  // Creates a Task object from a SQLite database row.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      subject: map['subject'] as String,
      dueDate: DateTime.parse(map['due_date'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  // Creates an updated copy without changing the original object.
  Task copyWith({
    int? id,
    String? title,
    String? subject,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, subject: $subject, '
        'dueDate: $dueDate, isCompleted: $isCompleted)';
  }
}