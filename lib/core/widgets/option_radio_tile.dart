import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';

class OptionRadioTile extends StatelessWidget {
  const OptionRadioTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = selected ? Colors.black : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: activeColor, width: 1.5),
              ),
              child: selected
                  ? Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
