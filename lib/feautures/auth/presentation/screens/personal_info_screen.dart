import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/constants/nigerian_states.dart';
import 'package:smartversemobile/core/widgets/app_dropdown_field.dart';
import 'package:smartversemobile/feautures/auth/presentation/screens/email_verification_screen.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_submit_button.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_text_field.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/personal_info_header.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/user_type_selector.dart';


class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key, required this.email});

  final String email;

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _phoneController = TextEditingController();
  String? _userType;
  String? _state;

  void _goToVerification() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => EmailVerificationScreen(email: widget.email)),
    );
  }

  void _handleCreateAccount() {
    if (_userType == null || _state == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select what best describes you and your state")),
      );
      return;
    }
    _goToVerification();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonalInfoHeader(onSkip: _goToVerification),
              SizedBox(height: 24.h),
              Text("I am a...", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.black)),
              SizedBox(height: 12.h),
              UserTypeSelector(value: _userType, onChanged: (v) => setState(() => _userType = v)),
              SizedBox(height: 20.h),
              AppDropdownField(
                label: "State",
                hint: "Select your state...",
                options: nigerianStates,
                value: _state,
                onChanged: (v) => setState(() => _state = v),
              ),
              SizedBox(height: 20.h),
              AuthTextField(
                label: "Phone number (optional)",
                hintText: "080x xxxx xxxx",
                controller: _phoneController,
              ),
              SizedBox(height: 32.h),
              AuthSubmitButton(text: "Create Account", onTap: _handleCreateAccount),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
