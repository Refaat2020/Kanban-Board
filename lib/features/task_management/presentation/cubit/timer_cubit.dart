import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/features/task_management/presentation/cubit/timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerState(formattedTime: "00:00:00", isRunning: false));

  late Stopwatch _stopwatch;
  Timer? _timer;

  Stopwatch get stopwatch => _stopwatch;

  void initializeStopwatch() {
    _stopwatch = Stopwatch();
  }

  void startTimer() {
    _stopwatch.start();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      emit(TimerState(
        formattedTime: _formatDuration(_stopwatch.elapsed),
        isRunning: true,
      ));
    });
  }

  void stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
    emit(TimerState(
      formattedTime: _formatDuration(_stopwatch.elapsed),
      isRunning: false,
    ));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
