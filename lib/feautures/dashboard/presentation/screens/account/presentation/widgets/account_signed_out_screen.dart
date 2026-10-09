import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_submit_button.dart';

class AccountSignedOutScreen extends StatelessWidget {
  const AccountSignedOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.main,
          padding: EdgeInsets.all(20.w),
          width: double.infinity,
          child: Text(
            "YOUR PROFILE",
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.appliancestext2.withOpacity(0.1),
                    border: Border.all(color: AppColors.appliancestext2.withOpacity(0.3), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/icons/boxicons_user-filled.svg',
                    width: 40.sp,
                    height: 40.sp,
                    colorFilter: const ColorFilter.mode(AppColors.appliancestext2, BlendMode.srcIn),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Not signed in",
                  style: TextStyle(fontFamily: 'Inter', color: AppColors.black, fontSize: 20.sp, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Sign in to save your calculations, export\nresults, and access your profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Inter', color: AppColors.grey700, fontSize: 14.sp, height: 1.4),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      AuthSubmitButton(
                        text: "Create Account",
                        onTap: () => Navigator.pushNamed(context, AppRoute.createAccount),
                      ),
                      SizedBox(height: 16.h),
                      _OutlineActionButton(
                        text: "Sign in to your account",
                        onTap: () => Navigator.pushNamed(context, AppRoute.login),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlineActionButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: const Color(0xFF2D5A9E)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'Inter', color: Color(0xFF2D5A9E), fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
