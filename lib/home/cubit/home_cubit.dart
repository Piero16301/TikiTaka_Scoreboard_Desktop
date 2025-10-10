import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.userRepository) : super(const HomeState());

  final UserRepository userRepository;

  void initCollections() {
    final matches = FirebaseFirestore.instance.collection(
      AppVariables.matchesCollection,
    );
    final configs = FirebaseFirestore.instance.collection(
      AppVariables.configsCollection,
    );

    emit(
      state.copyWith(
        matchesCollection: matches,
        configsCollection: configs,
      ),
    );
  }

  void reload({bool value = true}) {
    emit(state.copyWith(reload: value));
  }

  void addPiPMatch(int matchId) {
    final currentPiPMatches = List<int>.from(state.pipMatches);
    if (!currentPiPMatches.contains(matchId)) {
      currentPiPMatches
        ..clear()
        ..add(matchId);
      emit(state.copyWith(pipMatches: currentPiPMatches));
    }
  }

  void removePiPMatch(int matchId) {
    final currentPiPMatches = List<int>.from(state.pipMatches);
    if (currentPiPMatches.contains(matchId)) {
      currentPiPMatches.remove(matchId);
      emit(state.copyWith(pipMatches: currentPiPMatches));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMatches() {
    final enabledLeagues = userRepository.getEnabledLeagues();
    final nowDate = DateTime.now();
    // final nowDate = DateTime(2025, 10, 5);

    final snapshots = state.matchesCollection
        ?.where(
          'competition.code',
          whereIn: (enabledLeagues.isEmpty
              ? [AppVariables.emptyLeague]
              : enabledLeagues),
        )
        .where(
          'utcDate',
          isGreaterThan: DateTime(nowDate.year, nowDate.month, nowDate.day),
        )
        .where(
          'utcDate',
          isLessThan: DateTime(nowDate.year, nowDate.month, nowDate.day + 1),
        )
        .orderBy('utcDate', descending: false)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMatchConfigs() {
    final snapshots = state.configsCollection
        ?.where('id', isEqualTo: AppVariables.matchesCollection)
        .snapshots();

    return snapshots;
  }
}
