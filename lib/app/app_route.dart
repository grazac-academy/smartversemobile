import 'package:flutter/material.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/all_appliances.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/load_calculator_backup_only.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/saved_calculation.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/show_maths.dart';
import 'package:smartversemobile/feautures/splash_screen.dart';
import 'package:smartversemobile/feautures/auth/presentation/screens/create_account.dart';
import 'package:smartversemobile/feautures/auth/presentation/screens/create_account_success.dart';
import 'package:smartversemobile/feautures/auth/presentation/screens/login_screen.dart';
import 'package:smartversemobile/core/storage/onboarding_storage.dart';
import '../feautures/dashboard/dashboard_screen.dart';
import '../feautures/dashboard/presentation/screens/load Calculator/presentation/screens/calculated.dart';
import '../feautures/onboarding_screen.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/account/presentation/screens/help_support_screen.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/account/presentation/screens/location_screen.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/account/presentation/screens/edit_profile_screen.dart';

class AppRoute {
  static const String splash = '/';
  static const String onboarding = 'onboarding';
  static const String dashboardScreen = 'dashboardScreen';
  static const String kitchenScreen = 'kitchenScreen';
  static const String allAppliances = 'allAppliances';
  static const String calculated = 'calculated';
  static const String loadCalculatorBackupOnly = 'LoadCalculatorBackupOnly';
  static const String showMaths = 'showMaths';
  static const String savedCalculation = 'savedCalculation';
  static const String createAccount = '/create_account';
  static const String createAccountSuccess = '/create_account_success';
  static const String login = '/login';
  static const String helpSupport = 'helpSupport';
  static const String location = 'location';
  static const String editProfile = 'editProfile';

  static final routes = <String, Widget Function(BuildContext)>{
    splash: (context) => SplashScreen(
      onOnboardingFinish: () {},
    ),
    onboarding: (context) => OnboardingScreen(onFinish: (context) async {
      await OnboardingStorage.instance.markSeen();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, AppRoute.dashboardScreen);
    }),
    dashboardScreen: (context) => const DashboardScreen(),

    calculated: (context) => const CalculatedScreen(),
    loadCalculatorBackupOnly: (context)=> const LoadCalculatorBackupOnly(),
    showMaths: (context)=> const ShowMaths(),
    savedCalculation: (context)=> const SavedCalculation(),
    allAppliances: (context)=> const AllAppliances(),
    createAccount: (context) => const CreateAccount(),
    createAccountSuccess: (context) => const CreateAccountSuccess(),
    login: (context) => const LoginScreen(),
    helpSupport: (context) => const HelpSupportScreen(),
    location: (context) => const LocationScreen(),
    editProfile: (context) => const EditProfileScreen(),
  };
}