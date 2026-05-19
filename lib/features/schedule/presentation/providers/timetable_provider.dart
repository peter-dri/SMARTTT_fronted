import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/timetable_repository.dart';
import '../../domain/models/academic_term_model.dart';
import '../../domain/models/timetable_session_model.dart';

class TimetableState {
  final bool isLoading;
  final String? error;
  final AcademicTermModel? currentTerm;
  final List<TimetableSessionModel> sessions;

  TimetableState({
    this.isLoading = false,
    this.error,
    this.currentTerm,
    this.sessions = const [],
  });

  TimetableState copyWith({
    bool? isLoading,
    String? error,
    AcademicTermModel? currentTerm,
    List<TimetableSessionModel>? sessions,
  }) {
    return TimetableState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentTerm: currentTerm ?? this.currentTerm,
      sessions: sessions ?? this.sessions,
    );
  }
}

final timetableRepositoryProvider = Provider((ref) => TimetableRepository());

class TimetableNotifier extends Notifier<TimetableState> {
  late final TimetableRepository _repository;

  @override
  TimetableState build() {
    _repository = ref.watch(timetableRepositoryProvider);
    // Load state
    return TimetableState();
  }

  Future<void> fetchActiveTermAndSchedule() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final terms = await _repository.fetchCurrentTerms();
      if (terms.isNotEmpty) {
        final currentTerm = terms.first;
        final sessions = await _repository.fetchStudentTimetable(
          academicYear: currentTerm.academicYear,
          semester: currentTerm.semester,
        );
        state = TimetableState(
          isLoading: false,
          currentTerm: currentTerm,
          sessions: sessions,
        );
      } else {
        state = TimetableState(
          isLoading: false,
          error: 'No active academic term found on the server.',
        );
      }
    } catch (e) {
      state = TimetableState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchScheduleForTerm(String academicYear, int semester) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sessions = await _repository.fetchStudentTimetable(
        academicYear: academicYear,
        semester: semester,
      );
      state = state.copyWith(
        isLoading: false,
        sessions: sessions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final timetableProvider = NotifierProvider<TimetableNotifier, TimetableState>(
  TimetableNotifier.new,
);
