import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/core/network/token_storage.dart';

import '../../../../../../../../app/theme/app_colors.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/m_text.dart';
import 'result_bottom_sheet.dart';

class SaveAndShareC extends StatelessWidget {
  /// Saves the calculation. Should return the saved id, or null if it failed.
  /// Only called when the user is signed in.
  final Future<String?> Function()? onSaveAndShare;
  final VoidCallback? onShowMaths;

  final String saveButtonTitle;
  final String showMathsTitle;
  final Color? showMathsTextColor;
  final Widget? bottomSheetContent;

  const SaveAndShareC({
    super.key,
    this.onSaveAndShare,
    this.onShowMaths,
    this.saveButtonTitle = " Save & Share result",
    this.showMathsTitle = "Show the maths",
    this.showMathsTextColor,
    this.bottomSheetContent,
  });

  void _showSignInSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return bottomSheetContent ?? const SaveResultBottomSheet();
      },
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    // Signed out: show the sign in / create account sheet and stop.
    if (!TokenStorage.instance.isSignedIn) {
      _showSignInSheet(context);
      return;
    }

    // Signed in: save straight away, no sheet.
    final save = onSaveAndShare;
    if (save == null) return;

    final id = await save();
    if (!context.mounted) return;

    if (id != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved to your account")),
      );
      return;
    }

    // Save failed because the session is no longer valid (expired token):
    // the cubit cleared it, so show the sign in sheet, not an error.
    if (!TokenStorage.instance.isSignedIn) {
      _showSignInSheet(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to save calculation")),
    );
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
              title: saveButtonTitle,
              onTap: () => _handleSave(context),
            ),

            SizedBox(height: 8.h),
            InkWell(
              onTap: onShowMaths,
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
                    inputText: showMathsTitle,

                    size: 18.sp,
                    weight: FontWeight.w600,
                    textColor: showMathsTextColor ?? AppColors.textColor,
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