import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_state.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/calculation_detail.dart';

class AccountRecentCalculations extends StatelessWidget {
  const AccountRecentCalculations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculationCubit, CalculationState>(
      builder: (context, state) {
        final recentCalculations = state.savedCalculations;
        if (recentCalculations.isEmpty) {
          return const SizedBox.shrink();
        }
        final recent = recentCalculations.first;
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Calculations",
                    style: TextStyle(fontFamily: 'Inter', color: AppColors.appliancestext, fontSize: 14.sp, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "${recentCalculations.length} saved",
                    style: TextStyle(fontFamily: 'Inter', color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recent.label, style: TextStyle(fontFamily: 'Inter', color: AppColors.appliancestext, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4.h),
                        Text("${recent.distinctApplianceCount} appliances · ${recent.modeText}", style: TextStyle(fontFamily: 'Inter', color: AppColors.grey400, fontSize: 12.sp)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: recent.result.recommendation.inverterKva.toStringAsFixed(0), style: TextStyle(fontFamily: 'Inter', color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                            TextSpan(text: "kVA", style: TextStyle(fontFamily: 'Inter', color: AppColors.appliancestext, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text("${recent.result.recommendation.battery.capacityAh}Ah" + (recent.result.recommendation.solar.panelCount > 0 ? " · ${recent.result.recommendation.solar.panelCount} pnl" : ""), style: TextStyle(fontFamily: 'Inter', color: AppColors.grey400, fontSize: 11.sp)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
