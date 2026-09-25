import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';
import 'package:smartversemobile/core/widgets/search_text_field.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/appliance.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/appliance_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/appliance_state.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/appliance_category_card.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/category_display_data.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/running_total_banner.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/appliance_selectable_list.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/edit_wattage_sheet.dart';

import 'category_appliance_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController search = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    search.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ApplianceCubit>().searchAppliances(search.text);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    search.removeListener(_onSearchChanged);
    search.dispose();
    super.dispose();
  }

  Future<void> _editWattage(Appliance appliance, ApplianceState state) async {
    final result = await showEditWattageSheet(
      context,
      applianceName: appliance.name,
      imagePath: appliance.imageUrl,
      currentWattage: state.wattageOf(appliance),
    );
    if (result != null) context.read<ApplianceCubit>().setWattage(appliance.id, result);
  }

  void _openCategory(String categoryId, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryApplianceScreen(categoryId: categoryId, title: title, )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: BlocBuilder<ApplianceCubit, ApplianceState>(
            builder: (context, state) {
              if (state.status == ApplianceLoadStatus.loading || state.status == ApplianceLoadStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == ApplianceLoadStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MText(inputText: "Couldn't load appliances", textColor: AppColors.textColor, weight: FontWeight.w600, size: 16.spMin),
                      SizedBox(height: 8.h),
                      TextButton(
                        onPressed: () => context.read<ApplianceCubit>().loadAppliances(),
                        child: const Text("Try again"),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 69.h),
                    MText(inputText: "Build Your Load", size: 16.spMin, weight: FontWeight.w600, textColor: AppColors.textColor),
                    SizedBox(height: 24.h),

                    SearchTextField(search: search),
                    SizedBox(height: 20.h),
                    if (state.totalItems > 0) ...[
                      RunningTotalBanner(formattedLoad: state.formattedLoad, totalItems: state.totalItems),
                      SizedBox(height: 24.h),
                    ],
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoute.allAppliances),
                      child: Container(
                        width: 176.w,
                        height: 40.h,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14.r)),
                        child: Center(
                          child: MText(inputText: "ALL APPLIANCES", size: 16.spMin, weight: FontWeight.w700, textColor: AppColors.main),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    if (state.isSearching)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else if (state.searchQuery.isNotEmpty && state.displayedAppliances.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Center(
                          child: MText(
                            inputText: "No appliances match your search",
                            textColor: AppColors.textColor,
                            weight: FontWeight.w500,
                            size: 13.spMin,
                          ),
                        ),
                      )
                    else if (state.searchQuery.isNotEmpty)
                      ApplianceSelectableList(
                        appliances: state.displayedAppliances,
                        state: state,
                        onQuantityChanged: (id, qty) => context.read<ApplianceCubit>().setQuantity(id, qty),
                        onEditWattage: (a) => _editWattage(a, state),
                      )
                    else
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 22.w,
                        mainAxisSpacing: 33.h,
                        childAspectRatio: 170 / 165,
                        children: [
                          for (final category in state.categories.where((c) => CategoryDisplayData.isSupported(c.name)))
                            GestureDetector(
                              onTap: () => _openCategory(category.id, category.name),
                              child: ApplianceCategoryCard(
                                imageAsset: CategoryDisplayData.forName(category.name).imageAsset,
                                title: category.name,
                                subtitle: CategoryDisplayData.forName(category.name).subtitle,
                                addedCount: state.totalItemsInCategory(category.id),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}