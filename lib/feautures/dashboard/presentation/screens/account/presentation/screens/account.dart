import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartversemobile/core/di/service_locator.dart';
import 'package:smartversemobile/core/network/token_storage.dart';
import 'package:smartversemobile/feautures/auth/data/repository/auth_repository.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_submit_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_cubit.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_state.dart';
import 'package:smartversemobile/feautures/dashboard/data/models/calculation_detail.dart';

import '../widgets/solar_j.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TokenStorage.instance,
      builder: (context, _) {
        final isSignedIn = TokenStorage.instance.isSignedIn;
        return Scaffold(
          backgroundColor: isSignedIn ? AppColors.main : AppColors.white2,
          body: SafeArea(
            child: isSignedIn
                ? const _SignedInScreen()
                : const _SignedOutScreen(),
          ),
        );
      },
    );
  }
}

class _SignedInScreen extends StatefulWidget {
  const _SignedInScreen();

  @override
  State<_SignedInScreen> createState() => _SignedInScreenState();
}

class _SignedInScreenState extends State<_SignedInScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CalculationCubit>().loadSavedCalculations();
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    final parts = name.split(" ").where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "U";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return "${parts[0][0]}${parts[1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = TokenStorage.instance.fullName ?? "";
    final email = TokenStorage.instance.email ?? "";

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SMARTVERT",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: AppColors.white2,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          GestureDetector(
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
                    style: TextStyle(color: AppColors.appliancestext, fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(color: AppColors.appliancestext, fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        email,
                        style: TextStyle(color: AppColors.appliancestext2.withOpacity(0.7), fontSize: 13.sp),
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
                                style: TextStyle(color: AppColors.successGreen, fontSize: 10.sp, fontWeight: FontWeight.w600),
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
          ),
          SizedBox(height: 24.h),
          SolarJC(),
          SizedBox(height: 24.h),
          BlocBuilder<CalculationCubit, CalculationState>(
            builder: (context, state) {
              final recentCalculations = state.savedCalculations;
              if (recentCalculations.isEmpty) {
                return const SizedBox.shrink();
              }
              final recent = recentCalculations.first;
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Calculations",
                          style: TextStyle(color: AppColors.appliancestext, fontSize: 14.sp, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          "${recentCalculations.length} saved",
                          style: TextStyle(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(recent.label, style: TextStyle(color: AppColors.appliancestext, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                              SizedBox(height: 4.h),
                              Text("${recent.distinctApplianceCount} appliances · ${recent.modeText}", style: TextStyle(color: AppColors.grey400, fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: recent.result.recommendation.inverterKva.toStringAsFixed(0), style: TextStyle(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                                  TextSpan(text: "kVA", style: TextStyle(color: AppColors.appliancestext, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text("${recent.result.recommendation.battery.capacityAh}Ah" + (recent.result.recommendation.solar.panelCount > 0 ? " · ${recent.result.recommendation.solar.panelCount} pnl" : ""), style: TextStyle(color: AppColors.grey400, fontSize: 11.sp)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  svgAsset: 'assets/icons/boxicons_user-filled.svg',
                  iconBgColor: AppColors.usageC,
                  title: "My Profile",
                  subtitle: "Manage your personal information",
                  onTap: () => Navigator.pushNamed(context, AppRoute.editProfile),
                ),
                _buildDivider(),
                _buildMenuItem(
                  svgAsset: 'assets/icons/noto_house.svg',
                  iconBgColor: AppColors.usagePatternContainer,
                  title: "My Location",
                  subtitle: "Update your address and location",
                  onTap: () {Navigator.pushNamed(context, AppRoute.location);},
                ),
                _buildDivider(),
                _buildMenuItem(
                  imageAsset: 'assets/icons/lightning.png',
                  iconBgColor: AppColors.googleBgCreate,
                  title: "My Power Needs",
                  subtitle: "View and edit your appliances & usage",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuItem(
                  svgAsset: 'assets/icons/report_forms_regular.svg',
                  iconBgColor: AppColors.usageC,
                  title: "My Reports",
                  subtitle: "View your solar recommendations and history",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuItem(
                  svgAsset: 'assets/icons/question mark.svg',
                  iconBgColor: AppColors.googleBgCreate,
                  title: "Help & Support",
                  subtitle: "FAQs, contact us and more",
                  onTap: () {Navigator.pushNamed(context, AppRoute.helpSupport);},
                ),
                _buildDivider(),
                _buildMenuItem(
                  isLogout: true,
                  title: "Log Out",
                  subtitle: "Sign out of your account",
                  onTap: () => TokenStorage.instance.clear(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => _confirmAndDeleteAccount(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red.shade700),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "Delete account",
                style: TextStyle(color: Colors.red.shade700, fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    String? svgAsset,
    String? imageAsset,
    Color? iconBgColor,
    Color? iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
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
                    ? Image.asset(
                  imageAsset,
                  width: 22.sp,
                  height: 22.sp,
                  color: iconColor,
                )
                    : SvgPicture.asset(
                  svgAsset!,
                  width: 22.sp,
                  height: 22.sp,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                      : null,
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
                      color: isLogout ? Colors.red.shade700 : AppColors.appliancestext,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isLogout ? Colors.red.shade700 : AppColors.grey400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1), indent: 16.w, endIndent: 16.w);
  }

  Future<void> _confirmAndDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete account"),
        content: const Text(
          "This permanently deletes your account and all saved data. This can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text("Delete", style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await getIt<AuthRepository>().deleteAccount();
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your account has been deleted")),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}



class _SignedOutScreen extends StatelessWidget {
  const _SignedOutScreen();

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
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Sign in to save your calculations, export\nresults, and access your profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
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
          style: const TextStyle(color: Color(0xFF2D5A9E), fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}