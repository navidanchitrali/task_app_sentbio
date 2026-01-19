import 'task.dart';

class SimpleTask extends Task {
  SimpleTask({
    required super.id,
    required super.title,
    required super.description,
  });

  @override
  bool canComplete() => true;
}
