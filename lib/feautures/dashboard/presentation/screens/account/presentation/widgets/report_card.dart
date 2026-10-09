import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/calculation_detail.dart';

class ReportCard extends StatelessWidget {
  final CalculationDetail detail;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ReportCard({
    super.key,
    required this.detail,
    required this.expanded,
    required this.onTap,
    required this.onDelete,
  });

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
  static const _greenTile = Color(0xFFE8F3EE);

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
                    MText(inputText: detail.label, size: 16.spMin, weight: FontWeight.w700, textColor: AppColors.appliancestext, textAlign: TextAlign.left),
                    SizedBox(height: 4.h),
                    MText(inputText: "Generated ${_formatDate(detail.createdAt)}", size: 12.spMin, weight: FontWeight.w400, textColor: AppColors.searchtext, textAlign: TextAlign.left),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        _StatTile(value: "${_kva(rec.inverterKva)} kVA", label: "Inverter", bg: AppColors.googleBgCreate, valueColor: AppColors.primary),
                        SizedBox(width: 8.w),
                        _StatTile(value: "${rec.battery.capacityAh} Ah", label: "Battery", bg: AppColors.usagePatternContainer, valueColor: AppColors.appliancestext),
                        SizedBox(width: 8.w),
                        _StatTile(value: isOffGrid ? "${rec.solar.panelCount} pcs" : "—", label: "Panels", bg: _greenTile, valueColor: AppColors.appliancestext),
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
                            decoration: BoxDecoration(color: const Color(0x0DE87A2D), borderRadius: BorderRadius.circular(10.r), border: Border.all(color: const Color(0x33E87A2D))),
                            child: MText(inputText: "Delete", size: 13.spMin, weight: FontWeight.w600, textColor: AppColors.primary),
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
                    decoration: BoxDecoration(color: const Color(0xFFFCF1E9), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.primary.withOpacity(0.15))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MText(inputText: "REPORT DETAILS", size: 10.spMin, weight: FontWeight.w700, textColor: AppColors.black, textAlign: TextAlign.left),
                        SizedBox(height: 8.h),
                        _DetailRow(label: "Connected load", value: "$loadKw kW"),
                        SizedBox(height: 6.h),
                        _DetailRow(label: "Appliances assessed", value: "${detail.distinctApplianceCount}"),
                        SizedBox(height: 8.h),
                        MText(inputText: "$modeText system", size: 13.spMin, weight: FontWeight.w700, textColor: AppColors.black, textAlign: TextAlign.left),
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
  const _StatTile({required this.value, required this.label, required this.bg, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          children: [
            MText(inputText: value, size: 14.spMin, weight: FontWeight.w700, textColor: valueColor, maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 2.h),
            MText(inputText: label, size: 11.spMin, weight: FontWeight.w400, textColor: AppColors.textColor3),
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
      decoration: BoxDecoration(color: const Color(0x0D1D7A4E), borderRadius: BorderRadius.circular(16.r), border: Border.all(color: AppColors.usagePatternContainerText.withOpacity(0.3))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOffGrid) Image.asset("assets/images/☀️.png", width: 11, height: 11) else Icon(Icons.bolt, size: 12.sp, color: AppColors.usagePatternContainerText),
          SizedBox(width: 4.w),
          MText(inputText: text, size: 11.spMin, weight: FontWeight.w600, textColor: AppColors.usagePatternContainerText),
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
        MText(inputText: label, size: 13.spMin, weight: FontWeight.w400, textColor: AppColors.textColor3),
        MText(inputText: value, size: 13.spMin, weight: FontWeight.w700, textColor: AppColors.black),
      ],
    );
  }
}
