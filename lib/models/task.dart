class Task {
  const Task({
    this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isCompleted = false,
  });

  final int? id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final bool isCompleted;

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'due_date': dueDate.millisecondsSinceEpoch,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      subject: map['subject'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(
        map['due_date'] as int,
        isUtc: false,
      ),
      isCompleted: (map['is_completed'] as int?) == 1,
    );
  }

  String get dueLabel {
    final today = DateTime.now();
    final currentDay = DateTime(today.year, today.month, today.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDay == currentDay) {
      return 'Today';
    }

    final tomorrow = currentDay.add(const Duration(days: 1));
    if (dueDay == tomorrow) {
      return 'Tomorrow';
    }

    return '${_monthLabel(dueDate.month)} ${dueDate.day}';
  }

  static String _monthLabel(int month) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
