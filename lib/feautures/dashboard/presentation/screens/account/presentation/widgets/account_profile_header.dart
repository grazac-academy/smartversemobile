import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/network/token_storage.dart';

class AccountProfileHeader extends StatelessWidget {
  const AccountProfileHeader({super.key});

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    final parts = name.split(" ").where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "U";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TokenStorage.instance,
      builder: (context, child) {
        final name = TokenStorage.instance.fullName ?? "";
        final email = TokenStorage.instance.email ?? "";

        return GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: Text(
                  _getInitials(name),
                  style: TextStyle(fontFamily: 'Inter', color: AppColors.appliancestext, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.appliancestext, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      email,
                      style: TextStyle(fontFamily: 'Inter', color: AppColors.appliancestext2.withOpacity(0.7), fontSize: 13.sp),
                    ),
                    if (TokenStorage.instance.isEmailVerified) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withOpacity(0.1),
                          border: Border.all(color: AppColors.successGreen.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, size: 12.sp, color: AppColors.successGreen),
                            SizedBox(width: 4.w),
                            Text(
                              "Verified",
                              style: TextStyle(fontFamily: 'Inter', color: AppColors.successGreen, fontSize: 10.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
