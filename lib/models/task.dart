class Task {
  final String name;
  final String priority;
  final int duration;
  final String deadline;


  Task({required this.name, required this.priority, required this.duration, required this.deadline});

  @override
  // ini fungsinya untuk menampilkan informasi task dalam bentuk string
  String toString() {
    return 'Task{name: $name, priority: $priority, duration: $duration, deadline: $deadline}';
  }
}