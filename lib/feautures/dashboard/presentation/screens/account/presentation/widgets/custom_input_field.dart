import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? subLabel;
  final TextEditingController controller;
  /// When true, the field is not editable (e.g. an email that can't change).
  final bool readOnly;
  /// Border color override — used e.g. to show a green "locked" state.
  final Color? borderColor;
  /// Small note rendered under the field (e.g. "Email cannot be changed.").
  final String? helperText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.subLabel,
    this.readOnly = false,
    this.borderColor,
    this.helperText,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedBorderColor = borderColor ?? const Color(0xff9E9E9E);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: TextStyle(color: AppColors.appliancestext, fontSize: 16.sp, fontWeight: FontWeight.w400)),
              if (subLabel != null)
                TextSpan(text: ' $subLabel', style: TextStyle(color: AppColors.appliancestext, fontSize: 16.sp, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            color: readOnly ? AppColors.grey700 : AppColors.appliancestext,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Color(0xff9E9E9E), fontSize: 14.sp, fontWeight: FontWeight.w400),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: resolvedBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: readOnly ? resolvedBorderColor : AppColors.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: resolvedBorderColor),
            ),
          ),
        ),
        if (helperText != null) ...[
          SizedBox(height: 6.h),
          Text(
            helperText!,
            style: TextStyle(color: AppColors.grey600, fontSize: 11.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ],
    );
  }
}
