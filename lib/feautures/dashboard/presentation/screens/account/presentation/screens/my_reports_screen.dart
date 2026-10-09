import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/calculation_detail.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_state.dart';

import '../widgets/report_header.dart';
import '../widgets/report_overview_card.dart';
import '../widgets/report_card.dart';

const _pageBg = Color(0xFFFEFAF8);

enum ReportFilter { all, backup, offGrid }

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  ReportFilter _filter = ReportFilter.all;
  String? _expandedId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context.read<CalculationCubit>().loadSavedCalculations();
    if (mounted) setState(() => _loading = false);
  }

  void _goToCalculator() => Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppRoute.dashboardScreen, (route) => false);

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete this report?", style: TextStyle(fontFamily: 'Inter')),
        content: const Text("This can't be undone.", style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text("Cancel", style: TextStyle(fontFamily: 'Inter'))),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text("Delete", style: TextStyle(fontFamily: 'Inter'))),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final ok = await context.read<CalculationCubit>().deleteCalculation(id);
    if (!mounted) return;
    if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Couldn't delete report. Try again.")));
  }

  List<CalculationDetail> _applyFilter(List<CalculationDetail> all) {
    switch (_filter) {
      case ReportFilter.all: return all;
      case ReportFilter.backup: return all.where((d) => d.result.recommendation.solar.panelCount == 0).toList();
      case ReportFilter.offGrid: return all.where((d) => d.result.recommendation.solar.panelCount > 0).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CalculationCubit, CalculationState>(
          builder: (context, state) {
            final all = state.savedCalculations;
            final isEmpty = !_loading && all.isEmpty;

            return Column(
              children: [
                ReportHeader(showNew: isEmpty, onNew: _goToCalculator),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : isEmpty
                      ? _EmptyReports(onCreate: _goToCalculator)
                      : _buildContent(all),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<CalculationDetail> all) {
    final filtered = _applyFilter(all);
    final avgKva = all.fold<double>(0, (sum, d) => sum + d.result.recommendation.inverterKva.toDouble()) / all.length;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<CalculationCubit>().loadSavedCalculations(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          ReportOverviewCard(total: all.length, avgKva: avgKva),
          SizedBox(height: 16.h),
          _FilterTabs(selected: _filter, onChanged: (f) => setState(() { _filter = f; _expandedId = null; })),
          SizedBox(height: 16.h),
          if (filtered.isEmpty) const _NoReportsInCategory()
          else for (final detail in filtered) ReportCard(detail: detail, expanded: _expandedId == detail.id, onTap: () => setState(() => _expandedId = _expandedId == detail.id ? null : detail.id), onDelete: () => _confirmDelete(detail.id)),
        ],
      ),
    );
  }
}

class _EmptyReports extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyReports({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MText(inputText: "No reports yet", size: 24.spMin, weight: FontWeight.w700, textColor: AppColors.appliancestext),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: MText(inputText: "Complete a power needs calculation and save it to\ngenerate your first solar report.", size: 14.spMin, weight: FontWeight.w400, textColor: AppColors.searchtext),
          ),
          SizedBox(height: 60.h),
          GestureDetector(
            onTap: onCreate,
            child: Container(
              width: double.infinity,
              height: 58.h,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10.r)),
              alignment: Alignment.center,
              child: MText(inputText: "Create report", size: 18.spMin, weight: FontWeight.w600, textColor: AppColors.main),
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final ReportFilter selected;
  final ValueChanged<ReportFilter> onChanged;
  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(color: AppColors.main, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: AppColors.appliancestext2.withOpacity(0.12))),
      child: Row(children: [_tab("All", ReportFilter.all), _tab("Backup", ReportFilter.backup), _tab("Off-grid", ReportFilter.offGrid)]),
    );
  }

  Widget _tab(String label, ReportFilter value) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: isSelected ? AppColors.googleBgCreate : Colors.transparent, borderRadius: BorderRadius.circular(14.r)),
          child: MText(inputText: label, size: isSelected ? 16.spMin : 12.spMin, weight: isSelected ? FontWeight.w500 : FontWeight.w700, textColor: isSelected ? AppColors.primary : AppColors.appliancestext),
        ),
      ),
    );
  }
}

class _NoReportsInCategory extends StatelessWidget {
  const _NoReportsInCategory();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(color: AppColors.main, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        children: [
          MText(inputText: "No reports in this category", size: 14.spMin, weight: FontWeight.w700, textColor: const Color(0xFF1B2B2A)),
          SizedBox(height: 8.h),
          MText(inputText: "Try another filter or create a new calculation.", size: 12.spMin, weight: FontWeight.w400, textColor: AppColors.searchtext),
        ],
      ),
    );
  }
}