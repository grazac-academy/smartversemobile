import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class EditProfileStatus extends StatelessWidget {
  final bool isVerified;
  final DateTime? joinedAt;

  const EditProfileStatus({
    super.key,
    required this.isVerified,
    required this.joinedAt,
  });

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _joinedLabel {
    if (joinedAt == null) return '';
    return 'Joined ${_months[joinedAt!.month - 1]} ${joinedAt!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ACCOUNT STATUS",
          style: TextStyle(fontFamily: 'Inter', color: AppColors.black, fontSize: 12.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            if (isVerified)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withOpacity(0.1),
                  border: Border.all(color: AppColors.successGreen.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 14.sp, color: AppColors.successGreen),
                    SizedBox(width: 6.w),
                    Text(
                      "Verified",
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.successGreen, fontSize: 12.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            if (joinedAt != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.usageC,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12.sp, color: AppColors.grey700),
                    SizedBox(width: 6.w),
                    Text(
                      _joinedLabel,
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.grey700, fontSize: 12.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
