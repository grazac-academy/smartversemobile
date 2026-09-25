import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/core/network/token_storage.dart';

import '../../../../../../../../app/theme/app_colors.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/m_text.dart';
import '../../../../../bloc/calculation_cubit.dart';
import 'result_bottom_sheet.dart';

class SaveToAccountC extends StatefulWidget {
  const SaveToAccountC({super.key});

  @override
  State<SaveToAccountC> createState() => _SaveToAccountCState();
}

class _SaveToAccountCState extends State<SaveToAccountC> {
  bool _isSaving = false;
  bool _isSaved = false;

  void _showSignInSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SaveResultBottomSheet(),
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving || _isSaved) return;

    if (!TokenStorage.instance.isSignedIn) {
      _showSignInSheet();
      return;
    }

    setState(() => _isSaving = true);
    final id = await context.read<CalculationCubit>().saveCalculation("My Calculation");
    if (!mounted) return;

    setState(() => _isSaving = false);

    if (id != null) {
      setState(() => _isSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Calculation saved successfully")),
      );
      Navigator.pushNamed(context, '/saved-calculation-detail', arguments: id);
    } else if (!TokenStorage.instance.isSignedIn) {
      _showSignInSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save calculation")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      width: 393.w,
      decoration: BoxDecoration(
        color: AppColors.main,
      ),
      child: Center(
        child: Column(
          children: [
            AppButton(
              title: "Save To Account",
              onTap: (_isSaving || _isSaved) ? null : () => _handleSave(),
            ),

            SizedBox(height: 8.h),
            InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppRoute.dashboardScreen, (route) => false),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 365.w,
                height: 58.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.appliancestext2,
                    width: 1.w,
                  ),
                ),
                child: Center(
                  child: MText(
                    inputText: "↺ Start a new calculation",
                    size: 18.sp,
                    weight: FontWeight.w600,
                    textColor: Color(0XFF9E9E9E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}