import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_button.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/nigerian_context_c.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/power_mode.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/usage_info_card.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/hours_without_grid_power.dart';
import '../../../../../../../app/app_route.dart';
import '../../../../../../../core/widgets/app_bar_icon.dart';
import '../../../../bloc/appliance_cubit.dart';
import '../../../../bloc/appliance_state.dart';
import '../../../../bloc/calculation_cubit.dart';

enum PowerMode { backupOnly, offGridSolar }

class LoadCalculator extends StatefulWidget {
  const LoadCalculator({super.key});

  @override
  State<LoadCalculator> createState() => _LoadCalculatorState();
}

class _LoadCalculatorState extends State<LoadCalculator> {
  PowerMode? selectedMode = PowerMode.offGridSolar;
  int selectedHours = 6;
  bool _isCalculating = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplianceCubit, ApplianceState>(
      builder: (context, applianceState) {
        final estimatedLoad = applianceState.formattedLoad;
        final appliancesCount = applianceState.appliances.where((a) => applianceState.quantityOf(a.id) > 0).length;
        final dailyWh = applianceState.appliances.fold<num>(0, (sum, a) => sum + applianceState.quantityOf(a.id) * applianceState.wattageOf(a) * 24);
        final dailyKwh = (dailyWh / 1000).toStringAsFixed(1);

        return Scaffold(
          backgroundColor: AppColors.main,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 46.h),
                    Row(
                      children: [
                        AppbarIcon(onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                            AppRoute.dashboardScreen,
                                (route) => false,
                          );
                        }),
                        SizedBox(width: 67.w),
                        MText(inputText: "USAGE PATTERN", size: 16.spMin, weight: FontWeight.w700),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        Expanded(child: UsageInfoCard(value: estimatedLoad, label: "Estimated Load", valueColor: AppColors.primary)),
                        SizedBox(width: 16.w),
                        Expanded(child: UsageInfoCard(value: "$appliancesCount", label: "Appliances", valueColor: AppColors.appliancestext2)),
                        SizedBox(width: 16.w),
                        Expanded(child: UsageInfoCard(value: "${dailyKwh}kWh", label: "Est. daily energy", valueColor: AppColors.usagePatternContainerText)),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      width: 361.w,
                      decoration: BoxDecoration(color: AppColors.appliancesContainer, borderRadius: BorderRadius.circular(16.r)),
                      child: HoursWithoutGridPower(
                        initialHour: selectedHours,
                        onChanged: (h) => setState(() => selectedHours = h),
                      ),
                    ),
                    SizedBox(height: 16.4.h),
                    MText(inputText: "POWER MODE", size: 13.spMin, weight: FontWeight.w600, textColor: AppColors.powermode, family: "DM Sans"),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: PowerModeC(
                            imageAsset: 'assets/images/noto_house.png',
                            title: 'Backup only',
                            subtitle: 'Battery backup for outages - no solar panels required.',
                            titleColor: AppColors.appliancestext,
                            boderColor: selectedMode == PowerMode.backupOnly ? const Color(0x401D7A4E) : null,
                            onTap: () => setState(() => selectedMode = PowerMode.backupOnly),
                          ),
                        ),
                        SizedBox(width: 13.5.w),
                        Expanded(
                          child: PowerModeC(
                            imageAsset: 'assets/images/☀️.png',
                            title: 'Off-grid solar',
                            subtitle: 'Panels + battery - complete energy independence.',
                            titleColor: AppColors.usagePatternContainerText,
                            boderColor: selectedMode == PowerMode.offGridSolar ? const Color(0x401D7A4E) : null,
                            onTap: () => setState(() => selectedMode = PowerMode.offGridSolar),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    NigerianContextC(),
                    SizedBox(height: 18.81.h),
                    Container(
                      width: 390.w,
                      height: 94.h,
                      decoration: BoxDecoration(color: AppColors.main, border: Border.all(width: 0.97.w, color: const Color(0x0F0B1A33))),
                      child: Center(
                        child: AppButton(
                            title: "Calculate my system",
                            onTap: _isCalculating
                                ? null
                                : () async {
                              if (appliancesCount == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Select appliances to calculate")),
                                );
                                return;
                              }
                              setState(() => _isCalculating = true);
                              final calcCubit = context.read<CalculationCubit>();
                            calcCubit.setBackupHours(selectedHours);
                            calcCubit.setUsageMode(selectedMode == PowerMode.offGridSolar ? "OFF_GRID" : "BACKUP");
                            try {
                              await calcCubit.calculate(applianceState);
                              if (!context.mounted) return;
                              if (selectedMode == PowerMode.offGridSolar) {
                                Navigator.pushNamed(context, AppRoute.calculated);
                              } else {
                                Navigator.pushNamed(context, AppRoute.loadCalculatorBackupOnly);
                              }
                            } finally {
                              if (context.mounted) {
                                setState(() => _isCalculating = false);
                              }
                            }
                          },
                          child: _isCalculating
                              ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.main,
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}