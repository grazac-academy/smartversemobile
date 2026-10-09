import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';

class ReportOverviewCard extends StatelessWidget {
  final int total;
  final double avgKva;

  const ReportOverviewCard({super.key, required this.total, required this.avgKva});

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
          MText(inputText: "REPORT OVERVIEW", size: 11.spMin, weight: FontWeight.w400, textColor: AppColors.main, textAlign: TextAlign.left),
          SizedBox(height: 14.h),
          IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MText(inputText: "$total", size: 26.spMin, weight: FontWeight.w700, textColor: AppColors.main),
                    MText(inputText: "Total reports", size: 11.spMin, weight: FontWeight.w400, textColor: AppColors.main.withOpacity(0.8)),
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
                        MText(inputText: avgKva.toStringAsFixed(1), size: 26.spMin, weight: FontWeight.w700, textColor: AppColors.main),
                        SizedBox(width: 3.w),
                        MText(inputText: "kVA", size: 13.spMin, weight: FontWeight.w700, textColor: AppColors.main),
                      ],
                    ),
                    MText(inputText: "Average system", size: 11.spMin, weight: FontWeight.w400, textColor: AppColors.main.withOpacity(0.8)),
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
