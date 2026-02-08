import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/file_export.dart';

import '../../../cubit/timer_cubit.dart';
import '../../../cubit/timer_state.dart';

class TaskTimer extends StatefulWidget {
  final Function(Duration) onTimeElapsed;

  const TaskTimer({super.key, required this.onTimeElapsed});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  @override
  void initState() {
    super.initState();
    context.read<TimerCubit>().initializeStopwatch();
  }

  @override
  Widget build(BuildContext context) {
    final timerCubit = context.watch<TimerCubit>();

    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              "Timer: ${state.formattedTime}",
              style: context.textTheme.bodyLarge,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: state.isRunning
                      ? null
                      : () {
                          timerCubit.startTimer();
                          timerCubit.stream.listen((_) {
                            widget.onTimeElapsed(timerCubit.stopwatch.elapsed);
                          });
                        },
                  child: const Text(AppStrings.start),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: state.isRunning ? timerCubit.stopTimer : null,
                  child: const Text(AppStrings.stop),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
