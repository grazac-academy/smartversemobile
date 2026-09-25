import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class ContactItemCard extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String title;
  final String value;
  final String subtitle;
  final Color iconBgColor;
  final Color iconColor;

  const ContactItemCard({
    super.key,
    this.icon,
    this.svgPath,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconBgColor,
    required this.iconColor,
  }) : assert(icon != null || svgPath != null,
  'Provide either icon or svgPath');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Color(0x80EAEFF5),
              shape: BoxShape.circle,
            ),
            child: svgPath != null
                ? SvgPicture.asset(
              svgPath!,
              width: 24.w,
              height: 24.w,
            )
                : Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.appliancestext,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xff545454),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}