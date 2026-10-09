import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/calculation_detail.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_state.dart';

const _pageBg = Color(0xFFFEFAF8);
const _greenTile = Color(0xFFE8F3EE);

enum _ReportFilter { all, backup, offGrid }

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  _ReportFilter _filter = _ReportFilter.all;
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

  void _goToCalculator() {
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(AppRoute.dashboardScreen, (route) => false);
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete this report?"),
        content: const Text("This can't be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final ok = await context.read<CalculationCubit>().deleteCalculation(id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't delete report. Try again.")),
      );
    }
  }

  List<CalculationDetail> _applyFilter(List<CalculationDetail> all) {
    switch (_filter) {
      case _ReportFilter.all:
        return all;
      case _ReportFilter.backup:
        return all.where((d) => d.result.recommendation.solar.panelCount == 0).toList();
      case _ReportFilter.offGrid:
        return all.where((d) => d.result.recommendation.solar.panelCount > 0).toList();
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
                _Header(showNew: isEmpty, onNew: _goToCalculator),
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
          _OverviewCard(total: all.length, avgKva: avgKva),
          SizedBox(height: 16.h),
          _FilterTabs(
            selected: _filter,
            onChanged: (f) => setState(() {
              _filter = f;
              _expandedId = null;
            }),
          ),
          SizedBox(height: 16.h),
          if (filtered.isEmpty)
            const _NoReportsInCategory()
          else
            for (final detail in filtered)
              _ReportCard(
                detail: detail,
                expanded: _expandedId == detail.id,
                onTap: () => setState(() => _expandedId = _expandedId == detail.id ? null : detail.id),
                onDelete: () => _confirmDelete(detail.id),
              ),
        ],
      ),
    );
  }
}



class _Header extends StatelessWidget {
  final bool showNew;
  final VoidCallback onNew;

  const _Header({required this.showNew, required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.main,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(
        children: [
          AppbarIcon(onTap: () => Navigator.pop(context)),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(
                  inputText: "MY REPORTS",
                  size: 16.spMin,
                  weight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 2.h),
                MText(
                  inputText: "Your solar sizing history",
                  size: 11.spMin,
                  weight: FontWeight.w400,
                  textColor: AppColors.grey600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          if (showNew)
            GestureDetector(
              onTap: onNew,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: MText(
                  inputText: "+ New",
                  size: 13.spMin,
                  weight: FontWeight.w600,
                  textColor: AppColors.main,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ───────────────────────── Empty state ─────────────────────────

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
          MText(
            inputText: "No reports yet",
            size: 24.spMin,
            weight: FontWeight.w700,
            textColor: AppColors.appliancestext,
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: MText(
              inputText: "Complete a power needs calculation and save it to\ngenerate your first solar report.",
              size: 14.spMin,
              weight: FontWeight.w400,
              textColor: AppColors.searchtext,
            ),
          ),
          SizedBox(height: 60.h),
          GestureDetector(
            onTap: onCreate,
            child: Container(
              width: double.infinity,
              height: 58.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: MText(
                inputText: "Create report",
                size: 18.spMin,
                weight: FontWeight.w600,
                textColor: AppColors.main,
              ),
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}



class _OverviewCard extends StatelessWidget {
  final int total;
  final double avgKva;

  const _OverviewCard({required this.total, required this.avgKva});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.appliancestext2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MText(
            inputText: "REPORT OVERVIEW",
            size: 11.spMin,
            weight: FontWeight.w400,
            textColor: AppColors.main,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 14.h),
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MText(
                      inputText: "$total",
                      size: 26.spMin,
                      weight: FontWeight.w700,
                      textColor: AppColors.main,
                    ),
                    MText(
                      inputText: "Total reports",
                      size: 11.spMin,
                      weight: FontWeight.w400,
                      textColor: AppColors.main.withOpacity(0.8),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  color: AppColors.main.withOpacity(0.35),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        MText(
                          inputText: avgKva.toStringAsFixed(1),
                          size: 26.spMin,
                          weight: FontWeight.w700,
                          textColor: AppColors.main,
                        ),
                        SizedBox(width: 3.w),
                        MText(
                          inputText: "kVA",
                          size: 13.spMin,
                          weight: FontWeight.w700,
                          textColor: AppColors.main,
                        ),
                      ],
                    ),
                    MText(
                      inputText: "Average system",
                      size: 11.spMin,
                      weight: FontWeight.w400,
                      textColor: AppColors.main.withOpacity(0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final _ReportFilter selected;
  final ValueChanged<_ReportFilter> onChanged;

  const _FilterTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.appliancestext2.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          _tab("All", _ReportFilter.all),
          _tab("Backup", _ReportFilter.backup),
          _tab("Off-grid", _ReportFilter.offGrid),
        ],
      ),
    );
  }

  Widget _tab(String label, _ReportFilter value) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.googleBgCreate : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: MText(
            inputText: label,
            size: isSelected ? 16.spMin : 12.spMin,
            weight: isSelected ? FontWeight.w500 : FontWeight.w700,
            textColor: isSelected ? AppColors.primary : AppColors.appliancestext,
          ),
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
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          MText(
            inputText: "No reports in this category",
            size: 14.spMin,
            weight: FontWeight.w700,
            textColor: const Color(0xFF1B2B2A),
          ),
          SizedBox(height: 8.h),
          MText(
            inputText: "Try another filter or create a new calculation.",
            size: 12.spMin,
            weight: FontWeight.w400,
            textColor: AppColors.searchtext,
          ),
        ],
      ),
    );
  }
}



class _ReportCard extends StatelessWidget {
  final CalculationDetail detail;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReportCard({
    required this.detail,
    required this.expanded,
    required this.onTap,
    required this.onDelete,
  });

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

  String _formatDate(DateTime d) {
    final local = d.toLocal();
    return "${local.day} ${_months[local.month - 1]} ${local.year}";
  }

  String _kva(num v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final rec = detail.result.recommendation;
    final isOffGrid = rec.solar.panelCount > 0;
    final modeText = detail.modeText;
    final loadKw = (detail.result.summary.totalRunningLoadWatts / 1000).toStringAsFixed(1);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: AppColors.main,
                  border: Border(top: BorderSide(color: AppColors.primary, width: 2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MText(
                      inputText: detail.label,
                      size: 16.spMin,
                      weight: FontWeight.w700,
                      textColor: AppColors.appliancestext,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4.h),
                    MText(
                      inputText: "Generated ${_formatDate(detail.createdAt)}",
                      size: 12.spMin,
                      weight: FontWeight.w400,
                      textColor: AppColors.searchtext,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        _StatTile(
                          value: "${_kva(rec.inverterKva)} kVA",
                          label: "Inverter",
                          bg: AppColors.googleBgCreate,
                          valueColor: AppColors.primary,
                        ),
                        SizedBox(width: 8.w),
                        _StatTile(
                          value: "${rec.battery.capacityAh} Ah",
                          label: "Battery",
                          bg: AppColors.usagePatternContainer,
                          valueColor: AppColors.appliancestext,
                        ),
                        SizedBox(width: 8.w),
                        _StatTile(
                          value: isOffGrid ? "${rec.solar.panelCount} pcs" : "—",
                          label: "Panels",
                          bg: _greenTile,
                          valueColor: AppColors.appliancestext,
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ModeChip(text: modeText, isOffGrid: isOffGrid),
                        GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: const Color(0x0DE87A2D),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: const Color(0x33E87A2D)),
                            ),
                            child: MText(
                              inputText: "Delete",
                              size: 13.spMin,
                              weight: FontWeight.w600,
                              textColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFCF1E9),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MText(
                    inputText: "REPORT DETAILS",
                    size: 10.spMin,
                    weight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8.h),
                  _DetailRow(label: "Connected load", value: "$loadKw kW"),
                  SizedBox(height: 6.h),
                  _DetailRow(label: "Appliances assessed", value: "${detail.distinctApplianceCount}"),
                  SizedBox(height: 8.h),
                  MText(
                    inputText: "$modeText system",
                    size: 13.spMin,
                    weight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color valueColor;

  const _StatTile({
    required this.value,
    required this.label,
    required this.bg,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          children: [
            MText(
              inputText: value,
              size: 14.spMin,
              weight: FontWeight.w700,
              textColor: valueColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            MText(
              inputText: label,
              size: 11.spMin,
              weight: FontWeight.w400,
              textColor: AppColors.textColor3,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String text;
  final bool isOffGrid;

  const _ModeChip({required this.text, required this.isOffGrid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0x0D1D7A4E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.usagePatternContainerText.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOffGrid)
            Image.asset("assets/images/☀️.png", width: 11, height: 11)
          else
            Icon(Icons.bolt, size: 12.sp, color: AppColors.usagePatternContainerText),
          SizedBox(width: 4.w),
          MText(
            inputText: text,
            size: 11.spMin,
            weight: FontWeight.w600,
            textColor: AppColors.usagePatternContainerText,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MText(
          inputText: label,
          size: 13.spMin,
          weight: FontWeight.w400,
          textColor: AppColors.textColor3,
        ),
        MText(
          inputText: value,
          size: 13.spMin,
          weight: FontWeight.w700,
          textColor: AppColors.black,
        ),
      ],
    );
  }
}