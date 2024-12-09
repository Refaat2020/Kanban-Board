import 'package:dartz/dartz.dart';
import 'package:kanban_board/common/model/failure_model.dart';

import '../../file_export.dart';
import 'task_fail_mapper.dart';

extension TaskExcuter<T> on Future<T> {
  /// Executes the future with optional success and failure handlers.
  /// - [onFailed]: Callback for failure scenarios.
  /// - [onSuccess]: Callback for success scenarios.

  Future<void> execute({
    Function(FailureModel failed)? onFailed,
    Function(T value)? onSuccess,
  }) async {
    return await Task(() => this).attempt().mapFailure().run().then(
      (o) {
        return o.fold(
          (f) async {
            try {
              if (onFailed != null) await onFailed(f);
            } catch (e) {
              debugPrint('Execution failed: ${e.toString()}');
            }
          },
          (s) async {
            try {
              if (onSuccess != null) await onSuccess(s);
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        );
      },
    );
  }
}
