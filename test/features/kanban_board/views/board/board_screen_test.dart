import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/widgets/loading_state.dart';
import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/domain/cubit/kanban_cubit.dart';
import 'package:kanban_board/features/kanban_board/views/board/board_screen.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/repository/project_repository_test.mocks.dart';
import 'board_screen_test.mocks.dart';

@GenerateMocks([
  KanbanCubit,
  TaskManagementCubit,
])
void main() {
  late MockKanbanCubit mockKanbanCubit;
  late MockTaskManagementCubit mockTaskManagementCubit;
  late MockPreferenceStorage mockPreferenceStorage;

  setUp(() {
    locator.reset(); // Reset GetIt for a clean slate
    mockKanbanCubit = MockKanbanCubit();
    mockTaskManagementCubit = MockTaskManagementCubit();
    mockPreferenceStorage = MockPreferenceStorage();

    // Register mocks in GetIt
    locator.registerSingleton<PreferenceStorage>(mockPreferenceStorage);
    locator.registerSingleton<KanbanCubit>(mockKanbanCubit);
    locator.registerSingleton<TaskManagementCubit>(mockTaskManagementCubit);

    // Stub TaskManagementCubit's stream and state
    when(mockTaskManagementCubit.stream).thenAnswer((_) => Stream.empty());
    when(mockTaskManagementCubit.state).thenReturn(TaskManagementInitial());

    // Stub KanbanCubit's stream and state
    when(mockKanbanCubit.stream).thenAnswer((_) => Stream.empty());
    when(mockKanbanCubit.state).thenReturn(KanbanLoading());
    when(mockPreferenceStorage.getString(AppKeys.defaultProjectKey))
        .thenReturn('1');
  });

  testWidgets('renders loading state when KanbanCubit is loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<KanbanCubit>.value(value: mockKanbanCubit),
            BlocProvider<TaskManagementCubit>.value(
                value: mockTaskManagementCubit),
          ],
          child: const BoardScreen(),
        ),
      ),
    );

    // Verify the loading state is displayed
    expect(find.byType(LoadingState), findsOneWidget);
  });
}
