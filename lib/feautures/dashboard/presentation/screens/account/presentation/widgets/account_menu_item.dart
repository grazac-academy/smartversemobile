import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class AccountMenuItem extends StatelessWidget {
  final String? svgAsset;
  final String? imageAsset;
  final Color? iconBgColor;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLogout;

  const AccountMenuItem({
    super.key,
    this.svgAsset,
    this.imageAsset,
    this.iconBgColor,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            if (svgAsset != null || imageAsset != null) ...[
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: imageAsset != null
                    ? Image.asset(imageAsset!, width: 22.sp, height: 22.sp, color: iconColor)
                    : SvgPicture.asset(
                        svgAsset!,
                        width: 22.sp,
                        height: 22.sp,
                        colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
                      ),
              ),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: isLogout ? Colors.red.shade700 : AppColors.appliancestext,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontFamily: 'Inter', color: AppColors.grey600, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isLogout ? Colors.red.shade700 : AppColors.grey400, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
