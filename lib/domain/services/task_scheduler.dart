abstract class TaskScheduler {
  void schedule(Duration delay, void Function() callback);

  void cancelAll();
}
