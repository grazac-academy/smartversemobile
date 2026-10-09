import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class CreateAccountSuccess extends StatefulWidget {
  const CreateAccountSuccess({super.key});

  @override
  State<CreateAccountSuccess> createState() => _CreateAccountSuccessState();
}

class _CreateAccountSuccessState extends State<CreateAccountSuccess> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'savedCalculation');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.successGreen.withValues(alpha: 0.3),
                    blurRadius: 40.r,
                    spreadRadius: 10.r,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/images/check_mark.svg',
                width: 100.w,
                height: 100.h,
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              "You're in!",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Welcome to Smartverse",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey700,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
