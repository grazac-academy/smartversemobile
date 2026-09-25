import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import '../widgets/info_banner.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_input_field.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _selectedState;
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();

  final List<String> _nigerianStates = [
    'Lagos', 'Abuja', 'Kano', 'Rivers', 'Oyo', 'Kaduna', 'Ogun'
  ];

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    "LOCATION",
                    style: TextStyle(
                      color: AppColors.appliancestext,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17.h),
              Text(
                "Set your location below",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Location helps us give accurate solar data",
                style: TextStyle(
                  color: Color(0xff545454),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
               InfoBanner(
                 svgPath: "assets/icons/noto-v1_sun.svg",
                text: "Your state affects Nigeria's solar irradiance data and peak sun hours used in your calculations. Lagos averages 4.5 peak hours; northern states get up to 6.",
              ),
              SizedBox(height: 44.h),
              Text(
                "LOCATION DETAILS",
                style: TextStyle(
                  color: Color(0xFFF07030),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 18.h),
              CustomDropdown(
                label: "State",
                hintText: "Select your state...",
                value: _selectedState,
                items: _nigerianStates,
                onChanged: (val) => setState(() => _selectedState = val),
              ),
              SizedBox(height: 8.h),
              Text(
                "Your state determines solar irradiance in your area",
                style: TextStyle(color: AppColors.textColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 24.h),
              CustomInputField(
                label: "City / LGA",
                hintText: "Type your city or LGA",
                controller: _cityController,
              ),
              SizedBox(height: 24.h),
              CustomInputField(
                label: "Street address",
                subLabel: "(optional)",
                hintText: "e.g. 14 Bode Thomas Street",
                controller: _streetController,
              ),
              SizedBox(height: 8.h),
              Text(
                "Only used for personalisation, never shared",
                style: TextStyle(color: Color(0XFF545454), fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
