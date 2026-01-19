import 'task.dart';

class TimedTask extends Task {
  final DateTime dueTime;

  TimedTask({
    required super.id,
    required super.title,
    required super.description,
    required this.dueTime,
  });

  @override
  bool canComplete() {
    return DateTime.now().isAfter(dueTime);
  }
}
