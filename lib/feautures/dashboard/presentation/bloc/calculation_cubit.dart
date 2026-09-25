import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/calculation_request.dart';
import 'package:smartversemobile/core/error/exceptions.dart';
import 'package:smartversemobile/core/network/token_storage.dart';
import '../../data/repository/calculation_repository.dart';
import 'appliance_state.dart';
import 'calculation_state.dart';

class CalculationCubit extends Cubit<CalculationState> {
  CalculationCubit(this._repository) : super(const CalculationState());

  final CalculationRepository _repository;

  void setBackupHours(int hours) => emit(state.copyWith(backupHours: hours));

  void setUsageMode(String mode) => emit(state.copyWith(usageMode: mode));

  Future<void> calculate(ApplianceState applianceState) async {
    emit(state.copyWith(status: CalculationStatus.loading));
    try {
      final items = <CalculationRequestItem>[];
      for (final appliance in applianceState.appliances) {
        final qty = applianceState.quantityOf(appliance.id);
        if (qty > 0) {
          items.add(CalculationRequestItem(
            applianceId: appliance.id,
            quantity: qty,
            wattage: applianceState.wattageOf(appliance),
            hoursPerDay: 24,
          ));
        }
      }


      final request = CalculationRequest(
        usageMode: state.usageMode,
        backupHours: state.backupHours,
        items: items,
      );

      final result = await _repository.calculate(request);
      emit(state.copyWith(status: CalculationStatus.loaded, result: result));
    } catch (e) {
      debugPrint("Calculation failed: $e");
      emit(state.copyWith(status: CalculationStatus.error, errorMessage: e.toString()));
    }
  }

  Future<String?> saveCalculation(String label) async {
    if (state.result == null) return null;
    try {
      final id = await _repository.saveCalculation(calculationId: state.result!.calculationId, label: label);
      if (id != null) {
        await loadSavedCalculations();
      }
      return id;
    } catch (e) {
      debugPrint("Save calculation failed: $e");
      // Token missing/expired/rejected: treat the user as signed out so the UI
      // can show the sign in / create account sheet instead of a generic error.
      if (e is ServerException && (e.statusCode == 401 || e.statusCode == 403)) {
        await TokenStorage.instance.clear();
      }
      return null;
    }
  }

  Future<void> loadSavedCalculations() async {
    try {
      final list = await _repository.getSavedCalculations();
      emit(state.copyWith(savedCalculations: list));
    } catch (e) {
      debugPrint("Loading saved calculations failed: $e");
    }
  }

  void clearSavedCalculations() {
    emit(state.copyWith(savedCalculations: const []));
  }

  Future<void> loadSavedCalculationDetail(String id) async {
    try {
      final detail = await _repository.getSavedCalculationDetail(id);
      emit(state.copyWith(viewingDetail: detail));
    } catch (e) {
      debugPrint("Loading calculation detail failed: $e");
    }
  }

  Future<bool> deleteCalculation(String id) async {
    try {
      await _repository.deleteCalculation(id);
      final updated = state.savedCalculations.where((c) => c.id != id).toList();
      emit(state.copyWith(savedCalculations: updated));
      return true;
    } catch (e) {
      debugPrint("Delete calculation failed: $e");
      return false;
    }
  }
}