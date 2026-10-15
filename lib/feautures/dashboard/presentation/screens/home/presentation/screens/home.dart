import 'dart:async';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
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

import '../../../../../../../core/widgets/category_slot.dart';
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

  void _openCategory(CategorySlot slot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryApplianceScreen(categoryName: slot.backendName, title: slot.title)),
    );
  }

  int _addedCount(ApplianceState state, CategorySlot slot) {
    final id = state.categoryIdByName(slot.backendName);
    return id == null ? 0 : state.totalItemsInCategory(id);
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
              final isLoaded = state.status == ApplianceLoadStatus.loaded;
              final isLoading = state.status == ApplianceLoadStatus.initial || state.status == ApplianceLoadStatus.loading;
              final hasFailed = state.status == ApplianceLoadStatus.error;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 69.h),

                    MText(inputText: "Build Your Load", size: 16.spMin, weight: FontWeight.w600, textColor: AppColors.textColor),
                    SizedBox(height: 24.h),
                    IgnorePointer(
                      ignoring: !isLoaded,
                      child: Opacity(
                        opacity: isLoaded ? 1 : 0.5,
                        child: SearchTextField(search: search),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (state.totalItems > 0) ...[
                      RunningTotalBanner(formattedLoad: state.formattedLoad, totalItems: state.totalItems),
                      SizedBox(height: 24.h),
                    ],
                    Row(
                      children: [
                        GestureDetector(
                          onTap: isLoaded ? () => Navigator.pushNamed(context, AppRoute.allAppliances) : null,
                          child: Opacity(
                            opacity: isLoaded ? 1 : 0.5,
                            child: Container(
                              width: 176.w,
                              height: 40.h,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14.r)),
                              child: Center(
                                child: MText(inputText: "ALL APPLIANCES", size: 16.spMin, weight: FontWeight.w700, textColor: AppColors.main),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        if (isLoading) const CupertinoActivityIndicator(radius: 9),

                        if (hasFailed)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => context.read<ApplianceCubit>().loadAppliances(),
                            child: Padding(
                              padding: EdgeInsets.all(6.w),
                              child: Icon(Icons.refresh, size: 22.sp, color: AppColors.primary),
                            ),
                          ),
                      ],
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
                            for (final slot in homeCategorySlots)
                              GestureDetector(
                                onTap: isLoaded ? () => _openCategory(slot) : null,
                                child: Opacity(
                                  opacity: isLoaded ? 1 : 0.5,
                                  child: ApplianceCategoryCard(
                                    imageAsset: CategoryDisplayData.forName(slot.backendName).imageAsset,
                                    title: slot.title,
                                    subtitle: CategoryDisplayData.forName(slot.backendName).subtitle,
                                    addedCount: _addedCount(state, slot),
                                  ),
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