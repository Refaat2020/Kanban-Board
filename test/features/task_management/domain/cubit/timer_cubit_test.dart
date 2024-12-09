import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/task_management/data/models/timer_state.dart';
import 'package:kanban_board/features/task_management/domain/cubit/timer_cubit.dart';

void main() {
  late TimerCubit timerCubit;

  setUp(
    () {
      timerCubit = TimerCubit();
      timerCubit.initializeStopwatch();
    },
  );

  tearDown(
    () {
      timerCubit.close();
    },
  );

  test(
    'Initial state is 00:00:00',
    () {
      expect(timerCubit.state.formattedTime, "00:00:00");
    },
  );

  test(
    'Timer updates correctly',
    () async {
      timerCubit.startTimer();
      await Future.delayed(Duration(seconds: 2));
      timerCubit.stopTimer();
      expect(
        timerCubit.state.formattedTime,
        isNot("00:00:00"),
      ); // State should have elapsed time
    },
  );

  blocTest<TimerCubit, TimerState>(
    'emits [TimerState, TimerState] when timer start',
    build: () {
      return TimerCubit();
    },
    act: (bloc) async {
      bloc.initializeStopwatch();
      bloc.startTimer();
      await Future.delayed(
        Duration(seconds: 2),
      );
    },
    expect: () => [
      isA<TimerState>(),
      isA<TimerState>(),
    ],
  );
}
