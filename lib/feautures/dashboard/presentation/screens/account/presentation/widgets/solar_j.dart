import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../app/theme/app_colors.dart';
class SolarJC extends StatelessWidget {
  const SolarJC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.googleBgCreate,
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/noto-v1_sun.svg', width: 32.sp, height: 32.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Solar Journey",
                  style: TextStyle(color: AppColors.appliancestext2, fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Get personalized recommendations based on your power needs and location.",
                  style: TextStyle(color: AppColors.grey700, fontSize: 12.sp, height: 1.3),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}