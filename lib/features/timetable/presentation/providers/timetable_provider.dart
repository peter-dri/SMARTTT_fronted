import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable_slot.dart';
import '../../data/timetable_repository.dart';

final timetableProvider = FutureProvider<List<TimetableSlot>>((ref) {
  final timetableRepository = ref.watch(timetableRepositoryProvider);
  return timetableRepository.getTodaysTimetable();
});