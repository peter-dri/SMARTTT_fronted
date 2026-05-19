import 'dart:developer' as dev;
import '../../../core/network/api_client.dart';
import '../domain/models/academic_term_model.dart';
import '../domain/models/timetable_session_model.dart';

class TimetableRepository {
  Future<List<AcademicTermModel>> fetchCurrentTerms() async {
    try {
      dev.log('Fetching active academic terms...', name: 'TimetableRepository');
      final response = await apiClient.dio.get('timetable/terms/', queryParameters: {
        'is_current': 'true',
      });
      
      final dynamic results = response.data['results'];
      if (results is List) {
        return results.map((json) => AcademicTermModel.fromJson(json)).toList();
      }
      return [];
    } catch (e, stack) {
      dev.log('Error fetching current terms', error: e, stackTrace: stack, name: 'TimetableRepository');
      rethrow;
    }
  }

  Future<List<TimetableSessionModel>> fetchStudentTimetable({
    required String academicYear,
    required int semester,
  }) async {
    try {
      dev.log(
        'Fetching student timetable for $academicYear semester $semester...', 
        name: 'TimetableRepository'
      );
      final response = await apiClient.dio.get(
        'timetable/sessions/my-timetable/', 
        queryParameters: {
          'academic_year': academicYear,
          'semester': semester,
        }
      );

      final dynamic data = response.data;
      if (data is List) {
        return data.map((json) => TimetableSessionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e, stack) {
      dev.log(
        'Error fetching student timetable', 
        error: e, 
        stackTrace: stack, 
        name: 'TimetableRepository'
      );
      rethrow;
    }
  }
}
