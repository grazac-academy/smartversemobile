import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';
import 'package:smartversemobile/core/widgets/search_text_field.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/appliance_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/appliance_state.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/appliance_selectable_list.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/edit_wattage_sheet.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/load_summary_banner.dart';

import '../../../../../../../app/theme/app_colors.dart';
import '../../../../../dashboard_screen.dart';
import '../../../../../data/models/appliance.dart';

class CategoryApplianceScreen extends StatefulWidget {
  const CategoryApplianceScreen({super.key, required this.categoryName, required this.title});

  final String categoryName;
  final String title;

  @override
  State<CategoryApplianceScreen> createState() => _CategoryApplianceScreenState();
}

class _CategoryApplianceScreenState extends State<CategoryApplianceScreen> {
  final TextEditingController search = TextEditingController();

  Future<void> _editWattage(Appliance appliance, ApplianceState state) async {
    final result = await showEditWattageSheet(
      context,
      applianceName: appliance.name,
      imagePath: appliance.imageUrl,
      currentWattage: state.wattageOf(appliance),
    );
    if (result != null) context.read<ApplianceCubit>().setWattage(appliance.id, result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplianceCubit, ApplianceState>(
      builder: (context, state) {
        final isLoading = state.status == ApplianceLoadStatus.initial || state.status == ApplianceLoadStatus.loading;
        final categoryId = state.categoryIdByName(widget.categoryName) ?? '';
        final categoryAppliances = state.appliances.where((a) => a.categoryId == categoryId).toList();
        final hasSelection = state.totalItemsInCategory(categoryId) > 0;

        return Scaffold(
          backgroundColor: AppColors.main,
          body: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55.h),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(alignment: Alignment.centerLeft, child: AppbarIcon()),
                          MText(inputText: widget.title.toUpperCase(), textColor: AppColors.textColor, weight: FontWeight.w600, size: 16.spMin),
                        ],
                      ),
                      SizedBox(height: 23.h),
                      SearchTextField(search: search),
                      SizedBox(height: 18.h),
                      if (hasSelection) ...[
                        LoadSummaryBanner(
                          formattedLoad: ApplianceState.formatWatts(state.totalWattsInCategory(categoryId)),
                          totalItems: state.totalItemsInCategory(categoryId),
                        ),
                        SizedBox(height: 18.h),
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.kitchen),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (isLoading)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 60.h),
                            child: const Center(child: CircularProgressIndicator()),
                          )
                        else
                          ApplianceSelectableList(
                            appliances: categoryAppliances,
                            state: state,
                            onQuantityChanged: (id, qty) => context.read<ApplianceCubit>().setQuantity(id, qty),
                            onEditWattage: (a) => _editWattage(a, state),
                          ),
                        SizedBox(height: 60.h),
                        GestureDetector(
                          onTap: hasSelection
                              ? () {
                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const DashboardScreen(initialIndex: 1)),
                                  (route) => false,
                            );
                          }
                              : null,
                          child: Container(
                            width: 390.w,
                            height: 54.h,
                            decoration: BoxDecoration(
                              color: hasSelection ? AppColors.surgeText : AppColors.appliancesC,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: MText(
                                inputText: hasSelection ? "Continue" : "Add appliances to continue",
                                weight: FontWeight.w600,
                                size: 18.spMin,
                                textColor: hasSelection ? Colors.white : AppColors.appliancesCText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}