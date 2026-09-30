import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/storage/onboarding_storage.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onOnboardingFinish;

  const SplashScreen({super.key, required this.onOnboardingFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final next = OnboardingStorage.instance.hasSeenOnboarding
          ? AppRoute.dashboardScreen
          : AppRoute.onboarding;
      Navigator.pushReplacementNamed(context, next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final orangeSize = size.width * 0.78;
    final blueSize = size.width * 0.68;

    return Scaffold(
      backgroundColor: AppColors.main,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              left: size.width * 0.51 - orangeSize / 2,
              top: size.height * 0.264 - orangeSize / 2,
              width: orangeSize,
              height: orangeSize,
              child: Image.asset('assets/images/red.png', fit: BoxFit.contain),
            ),
            Positioned(
              left: size.width * 0.79 - blueSize / 2,
              top: size.height * 0.628 - blueSize / 2,
              width: blueSize,
              height: blueSize,
              child: Image.asset('assets/images/blue.png', fit: BoxFit.contain),
            ),
            SafeArea(
              child: Center(
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  width: 345.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}