import 'package:song_learn/domain/services/task_scheduler.dart';

class ScheduledJob {
  ScheduledJob(this.delay, this.callback);

  final Duration delay;
  final void Function() callback;
}

class FakeTaskScheduler implements TaskScheduler {
  final List<ScheduledJob> jobs = [];

  @override
  void schedule(Duration delay, void Function() callback) {
    jobs.add(ScheduledJob(delay, callback));
  }

  @override
  void cancelAll() {
    jobs.clear();
  }

  void flush() {
    final pending = List<ScheduledJob>.of(jobs);
    jobs.clear();
    for (final job in pending) {
      job.callback();
    }
  }

  void flushOnce() {
    if (jobs.isEmpty) return;
    final job = jobs.removeAt(0);
    job.callback();
  }
}
