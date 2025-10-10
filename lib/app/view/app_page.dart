import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:user_repository/user_repository.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required UserRepository userRepository,
    super.key,
  }) : _userRepository = userRepository;

  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(create: (_) => AppCubit(_userRepository)),
        ],
        child: PiPMaterialApp(
          debugShowCheckedModeBanner: false,
          pipParams: const PiPParams(
            pipWindowWidth: 225,
            pipWindowHeight: 100,
          ),
          home: const AppView(),
        ),
      ),
    );
  }
}
