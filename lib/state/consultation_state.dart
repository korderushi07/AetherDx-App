import 'package:flutter/material.dart';
import '../models/specialist_model.dart';
import '../core/network/api_service.dart';

enum ConsultationStatus { loading, success, empty, error }

class ConsultationState extends ChangeNotifier {
  List<SpecialistModel> _specialists = [];
  ConsultationStatus _status = ConsultationStatus.loading;
  String _searchQuery = '';
  String _selectedCity = 'Nagpur';
  String _specialistLabel = '';
  String _specialistType = '';
  String _condition = '';
  bool _noConsultationRequired = false;

  // Exposure of states
  List<SpecialistModel> get specialists => _specialists;
  ConsultationStatus get status => _status;
  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;
  String get specialistLabel => _specialistLabel;
  String get specialistType => _specialistType;
  String get condition => _condition;
  bool get noConsultationRequired => _noConsultationRequired;

  bool get isLoading => _status == ConsultationStatus.loading;
  bool get isError => _status == ConsultationStatus.error;
  bool get isEmpty => _status == ConsultationStatus.empty;
  bool get isSuccess => _status == ConsultationStatus.success;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String _mapConditionToBackend(String cond) {
    final lower = cond.toLowerCase();
    if (lower.contains('psoriasis')) {
      return 'psoriasis';
    } else if (lower.contains('liver') || lower.contains('terry')) {
      return 'liver_disease';
    } else if (lower.contains('healthy')) {
      return 'healthy';
    }
    return cond.trim().toLowerCase().replaceAll(' ', '_');
  }

  // Load specialists from API
  Future<void> fetchSpecialists({required String condition, required String city}) async {
    _status = ConsultationStatus.loading;
    _selectedCity = city;
    _condition = condition;
    _noConsultationRequired = false;
    notifyListeners();

    try {
      final mappedCondition = _mapConditionToBackend(condition);
      final response = await ApiService.getNearbySpecialists(
        condition: mappedCondition,
        city: city,
      );

      if (response['success'] == true) {
        final responseCondition = response['condition'] as String?;
        if (responseCondition == 'healthy' || response['specialistType'] == null) {
          _noConsultationRequired = true;
          _specialists = [];
          _status = ConsultationStatus.success;
        } else {
          _specialistType = response['specialistType'] as String? ?? '';
          _specialistLabel = response['specialistLabel'] as String? ?? '';
          final List<dynamic> data = response['data'] ?? [];
          _specialists = data.map((json) => SpecialistModel.fromJson(json)).toList();
          
          if (_specialists.isEmpty) {
            _status = ConsultationStatus.empty;
          } else {
            _status = ConsultationStatus.success;
          }
        }
      } else {
        _status = ConsultationStatus.error;
      }
    } catch (e) {
      _status = ConsultationStatus.error;
    }
    notifyListeners();
  }

  // Get the processed specialists list based on search query
  List<SpecialistModel> getProcessedSpecialists() {
    List<SpecialistModel> list = List.from(_specialists);

    // Apply search query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((spec) {
        return (spec.name?.toLowerCase().contains(query) ?? false) ||
            (spec.specialization?.toLowerCase().contains(query) ?? false) ||
            (spec.hospital?.toLowerCase().contains(query) ?? false) ||
            (spec.address?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return list;
  }
}
