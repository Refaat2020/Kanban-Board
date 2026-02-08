import 'package:kanban_board/common/widgets/error_state.dart';
import 'package:kanban_board/file_export.dart';

import '../../cubit/project_cubit.dart';
import '../board/board_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async =>
      await context.read<ProjectCubit>().getOrCreateProject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProjectCubit, ProjectState>(
        listener: (context, state) {
          if (state is ProjectLoaded) {

            GoRouter.of(context).go(BoardScreen.routePath);
          }
        },
        builder: (context, state) {
          if (state is ProjectError) {
            return ErrorState(state.errorMessage ?? "");
          }
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
