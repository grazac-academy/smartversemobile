import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import 'package:smartversemobile/core/widgets/search_text_field.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/appliance.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/appliance_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/appliance_state.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/add_appliances.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/appliance_selectable_list.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/edit_wattage_sheet.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/widgets/load_summary_banner.dart';

import '../../../../../../../core/widgets/m_text.dart';

class AllAppliances extends StatefulWidget {
  const AllAppliances({super.key});

  @override
  State<AllAppliances> createState() => _AllAppliancesState();
}

class _AllAppliancesState extends State<AllAppliances> {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplianceCubit, ApplianceState>(
      builder: (context, state) {
        if (state.status == ApplianceLoadStatus.loading || state.status == ApplianceLoadStatus.initial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.status == ApplianceLoadStatus.error) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.read<ApplianceCubit>().loadAppliances(),
                child: const Text("Couldn't load appliances — Try again"),
              ),
            ),
          );
        }

        final hasSelection = state.totalItems > 0;

        return Scaffold(
          backgroundColor: AppColors.main,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(

                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 55.h),
                        Row(
                          children: [
                            AppbarIcon(),
                            SizedBox(width: 64.w),
                            MText(inputText: "ALL APPLIANCES", textColor: AppColors.textColor, weight: FontWeight.w700, size: 16.spMin),
                          ],
                        ),
                        SizedBox(height: 23.h),
                        SearchTextField(search: search),
                        SizedBox(height: 9.h),
                        if (hasSelection) ...[
                          SizedBox(height: 9.h),
                          LoadSummaryBanner(formattedLoad: state.formattedLoad, totalItems: state.totalItems),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 9.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.kitchen),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      children: [

                        if (state.isSearching)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: const CircularProgressIndicator(),
                          )
                        else if (state.searchQuery.isNotEmpty && state.displayedAppliances.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: MText(
                              inputText: "No appliances match your search",
                              textColor: AppColors.textColor,
                              weight: FontWeight.w500,
                              size: 13.spMin,
                            ),
                          )
                        else
                          ApplianceSelectableList(
                            appliances: state.displayedAppliances,
                            state: state,
                            onQuantityChanged: (id, qty) => context.read<ApplianceCubit>().setQuantity(id, qty),
                            onEditWattage: (a) => _editWattage(a, state),
                          ),
                        SizedBox(height: 74.34.h),
                        AddAppliances(hasSelection: hasSelection, onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}