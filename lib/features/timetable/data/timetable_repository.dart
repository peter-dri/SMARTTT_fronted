import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../domain/entities/timetable_slot.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(
    apiClient: apiClient.dio,
  );
});

class TimetableRepository {
  final Dio apiClient;

  TimetableRepository({
    required this.apiClient,
  });

  static const Map<int, String> _weekdayMap = {
    DateTime.monday: 'mon',
    DateTime.tuesday: 'tue',
    DateTime.wednesday: 'wed',
    DateTime.thursday: 'thu',
    DateTime.friday: 'fri',
    DateTime.saturday: 'sat',
    DateTime.sunday: 'sun',
  };

  Future<String?> _getCurrentTermId() async {
    final response = await apiClient.get(
      'timetable/terms/',
      queryParameters: {'is_current': true},
    );

    final data = response.data;
    final List<dynamic> results = (data is Map && data['results'] is List)
        ? (data['results'] as List<dynamic>)
        : (data is List ? data : const <dynamic>[]);

    if (results.isEmpty) return null;
    final first = results.first;
    if (first is Map<String, dynamic>) {
      return (first['id'] ?? '').toString();
    }
    if (first is Map) {
      return (first['id'] ?? '').toString();
    }
    return null;
  }

  Future<List<TimetableSlot>> getTodaysTimetable() async {
    try {
      final termId = await _getCurrentTermId();
      if (termId == null || termId.isEmpty) return <TimetableSlot>[];

      final dayOfWeek = _weekdayMap[DateTime.now().weekday];
      if (dayOfWeek == null) return <TimetableSlot>[];

      final response = await apiClient.get('timetable/slots/', queryParameters: {
        'term': termId,
        'day_of_week': dayOfWeek,
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> data = (responseData is Map && responseData['results'] is List)
            ? (responseData['results'] as List<dynamic>)
            : (responseData is List ? responseData : const <dynamic>[]);
        return data
            .map((slotJson) => TimetableSlot.fromJson(slotJson))
            .toList();
      } else {
        throw Exception('Failed to load timetable: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching timetable: $e');
    }
  }

  Future<List<TimetableSlot>> getTimetableByTerm(String termId) async {
    try {
      final response = await apiClient.get(
        'timetable/slots/',
        queryParameters: {
          'term': termId,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> data = (responseData is Map && responseData['results'] is List)
            ? (responseData['results'] as List<dynamic>)
            : (responseData is List ? responseData : const <dynamic>[]);
        return data
            .map((slotJson) => TimetableSlot.fromJson(slotJson))
            .toList();
      } else {
        throw Exception('Failed to load timetable: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching timetable: $e');
    }
  }
}