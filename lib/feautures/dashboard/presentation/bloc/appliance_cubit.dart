import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../data/repository/appliance_repository.dart';
import 'appliance_state.dart';

class ApplianceCubit extends Cubit<ApplianceState> {
  ApplianceCubit(this._repository) : super(const ApplianceState());

  final ApplianceRepository _repository;

  Future<void> loadAppliances() async {
    emit(state.copyWith(status: ApplianceLoadStatus.loading));
    try {
      final appliances = await _repository.getAppliances();
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        status: ApplianceLoadStatus.loaded,
        appliances: appliances,
        categories: categories,
      ));
    } catch (e) {
      debugPrint("Appliance load failed: $e");
      emit(state.copyWith(status: ApplianceLoadStatus.error, errorMessage: e.toString()));
    }
  }

  void setQuantity(String id, int quantity) {
    final updated = Map<String, int>.from(state.quantities)..[id] = quantity;
    emit(state.copyWith(quantities: updated));
  }

  void setWattage(String id, int wattage) {
    final updated = Map<String, int>.from(state.wattageOverrides)..[id] = wattage;

    emit(state.copyWith(wattageOverrides: updated));
  }

  Future<void> searchAppliances(String query) async {
    final trimmed = query.trim();
    emit(state.copyWith(searchQuery: trimmed));
    if (trimmed.isEmpty) return;

    emit(state.copyWith(isSearching: true));
    try {
      final results = await _repository.searchAppliances(trimmed);
      emit(state.copyWith(searchResults: results, isSearching: false));
    } catch (e) {
      debugPrint("Appliance search failed: $e");
      emit(state.copyWith(isSearching: false));
    }
  }
}