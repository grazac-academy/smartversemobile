import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';

class PersonalInfoHeader extends StatelessWidget {
  const PersonalInfoHeader({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppbarIcon(),
            GestureDetector(
              onTap: onSkip,
              child: Text("Skip", style: TextStyle(fontSize: 14.sp, color: AppColors.black, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text("Tell us about yourself", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: AppColors.black)),
        SizedBox(height: 6.h),
        Text(
          "We'll use this to personalize your solar recommendation.",
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
