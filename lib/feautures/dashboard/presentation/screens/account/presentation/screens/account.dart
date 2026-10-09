import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/di/service_locator.dart';
import 'package:smartversemobile/core/network/token_storage.dart';
import 'package:smartversemobile/feautures/auth/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/bloc/calculation_cubit.dart';

import '../widgets/solar_j.dart';
import '../widgets/account_menu_item.dart';
import '../widgets/account_profile_header.dart';
import '../widgets/account_recent_calculations.dart';
import '../widgets/account_signed_out_screen.dart';

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
            child: isSignedIn ? const _SignedInScreen() : const AccountSignedOutScreen(),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/Icon.png', width: 148.w, height: 46.h, fit: BoxFit.contain, alignment: Alignment.centerLeft),
              Container(padding: EdgeInsets.all(8.w), decoration: const BoxDecoration(color: AppColors.white2, shape: BoxShape.circle)),
            ],
          ),
          SizedBox(height: 24.h),
          const AccountProfileHeader(),
          SizedBox(height: 24.h),
          SolarJC(),
          SizedBox(height: 24.h),
          const AccountRecentCalculations(),
          SizedBox(height: 24.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                AccountMenuItem(svgAsset: 'assets/icons/boxicons_user-filled.svg', iconBgColor: AppColors.usageC, title: "My Profile", subtitle: "Manage your personal information", onTap: () => Navigator.pushNamed(context, AppRoute.editProfile)),
                _buildDivider(),
                AccountMenuItem(svgAsset: 'assets/icons/noto_house.svg', iconBgColor: AppColors.usagePatternContainer, title: "My Location", subtitle: "Update your address and location", onTap: () => Navigator.pushNamed(context, AppRoute.location)),
                _buildDivider(),
                AccountMenuItem(imageAsset: 'assets/icons/lightning.png', iconBgColor: AppColors.googleBgCreate, title: "My Power Needs", subtitle: "View and edit your appliances & usage", onTap: () {}),
                _buildDivider(),
                AccountMenuItem(svgAsset: 'assets/icons/report_forms_regular.svg', iconBgColor: AppColors.usageC, title: "My Reports", subtitle: "View your solar recommendations and history", onTap: () => Navigator.pushNamed(context, AppRoute.myReports)),
                _buildDivider(),
                AccountMenuItem(svgAsset: 'assets/icons/question mark.svg', iconBgColor: AppColors.googleBgCreate, title: "Help & Support", subtitle: "FAQs, contact us and more", onTap: () => Navigator.pushNamed(context, AppRoute.helpSupport)),
                _buildDivider(),
                AccountMenuItem(isLogout: true, title: "Log Out", subtitle: "Sign out of your account", onTap: () {
                  context.read<CalculationCubit>().clearSavedCalculations();
                  TokenStorage.instance.clear();
                }),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => _confirmAndDeleteAccount(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(border: Border.all(color: Colors.red.shade700), borderRadius: BorderRadius.circular(10.r)),
              alignment: Alignment.center,
              child: Text("Delete account", style: TextStyle(fontFamily: 'Inter', color: Colors.red.shade700, fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1), indent: 16.w, endIndent: 16.w);

  Future<void> _confirmAndDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete account", style: TextStyle(fontFamily: 'Inter')),
        content: const Text("This permanently deletes your account and all saved data. This can't be undone.", style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text("Cancel", style: TextStyle(fontFamily: 'Inter'))),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text("Delete", style: TextStyle(fontFamily: 'Inter', color: Colors.red.shade700))),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.of(context);
    rootNavigator.push(DialogRoute<void>(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator())));
    try {
      await getIt<AuthRepository>().deleteAccount();
      rootNavigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text("Your account has been deleted")));
      if (context.mounted) context.read<CalculationCubit>().clearSavedCalculations();
      await TokenStorage.instance.clear();
    } catch (e) {
      rootNavigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}