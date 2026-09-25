import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';

import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/action_options_card.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/based.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/microwave_x.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/recommended_inverter_card.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/save_share.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/save_to_account_c.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/widgets/saved_r.dart';

import '../../../../../../auth/presentation/cubit/pdf_export_cubit.dart';
import '../../../../bloc/calculation_cubit.dart';
import '../../../../bloc/calculation_state.dart';

class SavedCalculation extends StatelessWidget {
  const SavedCalculation({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isViewingSaved = args?['isViewingSaved'] == true;

    return BlocProvider(
      create: (_) => PdfExportCubit(),
      child: BlocListener<PdfExportCubit, PdfExportState>(
        listenWhen: (previous, current) =>
        current.status == PdfExportStatus.generated ||
            current.status == PdfExportStatus.failure,

        listener: (context, pdfState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(pdfState.message ?? '')));
        },
        child: BlocBuilder<CalculationCubit, CalculationState>(
          builder: (context, state) {
            final result = isViewingSaved ? state.viewingDetail?.result : state.result;
            if (result == null) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final rec = result.recommendation;
            final voltageText = rec.battery.systemVoltage?.toString() ?? "—";
            final panelWattsText = rec.solar.panelWatts?.toString() ?? "—";

            return Scaffold(
              backgroundColor: AppColors.main,
              body: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecommendedInverterCard(kva: rec.inverterKva.toInt(), date: DateTime.now()),
                          SizedBox(height: 14.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(child: SavedR(title: 'Battery', subTitle: '${rec.battery.capacityAh}Ah/${voltageText}V')),
                                SizedBox(width: 8.w),
                                Expanded(child: SavedR(title: 'Solar', subTitle: rec.solar.panelCount > 0 ? '${rec.solar.panelCount} pnl' : '—')),
                                SizedBox(width: 8.w),
                                Expanded(child: SavedR(title: 'Daily energy', subTitle: '${(result.summary.dailyEnergyWh / 1000).toStringAsFixed(1)}kWh')),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.w),
                            child: Column(
                              children: [
                                for (final b in result.breakdown) ...[
                                  Row(
                                    children: [
                                      MText(inputText: "${b.applianceName} ×${b.quantity}", size: 12.spMin, weight: FontWeight.w400, textColor: AppColors.appliancestext),
                                      const Spacer(),
                                      MText(inputText: "${b.wattage}W", size: 11.spMin, weight: FontWeight.w700, textColor: AppColors.appliancestext2),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                            child: Based(
                              message: "Based on the appliances you selected, we recommend a "
                                  "${rec.inverterKva.toStringAsFixed(0)} kVA inverter, "

                                  "a ${rec.battery.capacityAh}Ah/${voltageText}V battery bank, "
                                  "${rec.solar.panelCount > 0 ? 'and ${rec.solar.panelCount} × ${panelWattsText}W solar panels' : 'and no solar panels needed (backup-only mode)'}.",
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                            child: ActionOptionsCard(
                              onDownloadPdf: () => context.read<PdfExportCubit>().downloadPdf(result),
                              onShareWhatsApp: () => context.read<PdfExportCubit>().sharePdf(result),
                            ),
                          ),
                          SizedBox(height: 11.22.h),
                          Center(
                            child: MText(
                              inputText: "Calculations based on industry standards · smartvert.ng",
                              textColor: const Color(0xff9E9E9E),
                              size: 9.spMin,
                              weight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 15.15.h),
                          SaveToAccountC(),
                        ],
                      ),
                    ),
                  ),

                  // Loading overlay while the PDF is being generated
                  BlocBuilder<PdfExportCubit, PdfExportState>(
                    buildWhen: (previous, current) => previous.isBusy != current.isBusy,
                    builder: (context, pdfState) {

                      if (!pdfState.isBusy) return const SizedBox.shrink();
                      return Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black38,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  SizedBox(height: 14.h),
                                  MText(
                                    inputText: 'Generating PDF...',
                                    size: 14.spMin,
                                    weight: FontWeight.w500,
                                    textColor: AppColors.textColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

            );
          },
        ),
      ),
    );
  }
}