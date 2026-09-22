import 'dart:async';

import '../../domain/services/task_scheduler.dart';

class DartTaskScheduler implements TaskScheduler {
  final List<Timer> _timers = [];

  @override
  void schedule(Duration delay, void Function() callback) {
    _timers.add(Timer(delay, callback));
  }

  @override
  void cancelAll() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }
}
