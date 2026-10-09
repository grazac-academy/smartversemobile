import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import 'package:smartversemobile/core/widgets/m_text.dart';

class ReportHeader extends StatelessWidget {
  final bool showNew;
  final VoidCallback onNew;

  const ReportHeader({super.key, required this.showNew, required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.main,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(
        children: [
          AppbarIcon(onTap: () => Navigator.pop(context)),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MText(inputText: "MY REPORTS", size: 16.spMin, weight: FontWeight.w700, textColor: AppColors.black, textAlign: TextAlign.left),
                SizedBox(height: 2.h),
                MText(inputText: "Your solar sizing history", size: 11.spMin, weight: FontWeight.w400, textColor: AppColors.grey600, textAlign: TextAlign.left),
              ],
            ),
          ),
          if (showNew)
            GestureDetector(
              onTap: onNew,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12.r)),
                child: MText(inputText: "+ New", size: 13.spMin, weight: FontWeight.w600, textColor: AppColors.main),
              ),
            ),
        ],
      ),
    );
  }
}
