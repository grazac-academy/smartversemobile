import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/di/service_locator.dart';
import 'package:smartversemobile/core/network/token_storage.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import 'package:smartversemobile/feautures/auth/data/models/user_response_model.dart';
import 'package:smartversemobile/feautures/auth/data/repository/auth_repository.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_text_field.dart';

import '../widgets/custom_input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoadingProfile = true;
  bool _isSaving = false;
  bool _isVerified = false;
  DateTime? _joinedAt;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    // Show what we already have locally right away, then refresh from
    // the server for the phone number / verified status / joined date,
    // none of which TokenStorage caches locally.
    _nameController.text = TokenStorage.instance.fullName ?? '';
    _emailController.text = TokenStorage.instance.email ?? '';
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final UserResponseModel profile = await getIt<AuthRepository>().getProfile();
      if (!mounted) return;
      setState(() {
        _nameController.text = profile.fullName;
        _emailController.text = profile.email;
        _phoneController.text = profile.phoneNumber ?? '';
        _isVerified = profile.isEmailVerified;
        _joinedAt = profile.createdAt;
        _isLoadingProfile = false;
      });
    } catch (_) {
      // Fall back to the cached name/email already set in initState and
      // just let the user edit those; phone/verified/joined stay blank.
      if (!mounted) return;
      setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Full name can't be empty")),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final updated = await getIt<AuthRepository>().updateProfile(
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _nameController.text = updated.fullName;
        _phoneController.text = updated.phoneNumber ?? '';
        _isVerified = updated.isEmailVerified;
        _joinedAt = updated.createdAt ?? _joinedAt;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String get _joinedLabel {
    if (_joinedAt == null) return '';
    return 'Joined ${_months[_joinedAt!.month - 1]} ${_joinedAt!.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: SafeArea(
        child: _isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Row(
                children: [
                  AppbarIcon(onTap: () => Navigator.pop(context)),
                  SizedBox(width: 16.w),
                  Text(
                    "EDIT PROFILE",
                    style: TextStyle(
                      color: AppColors.appliancestext,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text(
                "PERSONAL INFORMATION",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 18.h),
              CustomInputField(
                label: "Full Name",
                hintText: "Enter your full name",
                controller: _nameController,
              ),
              SizedBox(height: 24.h),
              CustomInputField(
                label: "Email Address",
                hintText: "you@example.com",
                controller: _emailController,
                readOnly: true,
                borderColor: AppColors.successGreen,
                helperText: "Email cannot be changed. Contact support if needed.",
              ),
              SizedBox(height: 24.h),
              AuthTextField(
                label: "Phone number",
                hintText: "080X XXXX XXX",
                controller: _phoneController,
                isPassword: true,
                prefixIconData: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 24.h),
              Text(
                "ACCOUNT STATUS",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  if (_isVerified)
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
                            style: TextStyle(color: AppColors.successGreen, fontSize: 12.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  if (_joinedAt != null)
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
                            style: TextStyle(color: AppColors.grey700, fontSize: 12.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 40.h),
              GestureDetector(
                onTap: _isSaving ? null : _saveChanges,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: _isSaving
                      ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                      : Text(
                    "Save changes",
                    style: TextStyle(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}