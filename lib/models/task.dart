class Task {
  final String name;
  final String priority;
  final int duration;
  final String deadlinel;


  Task({required this.name, required this.priority, required this.duration, required this.deadlinel});

  @override
  String toString() {
    return 'Task{name: $name, priority: $priority, duration: $duration, deadline: $deadlinel}';
  }
}