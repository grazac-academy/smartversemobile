import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../app/theme/app_colors.dart';
import '../../../../../../../../core/widgets/m_text.dart';

class RecommendedInverterCard extends StatelessWidget {
  const RecommendedInverterCard({
    super.key,
    required this.kva,
    required this.date,
  });

  final int kva;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(20),

        gradient: const RadialGradient(
          center: Alignment(0.1, -0.6),
          radius: 1.1,
          colors: [
            Color(0x40E87A2D),
            Colors.transparent,
          ],
          stops: [0.0, 0.7],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MText(inputText: "Smartvert", size: 17,),
              MText(
                inputText: DateFormat('d MMMM yyyy').format(date),
                size: 14.spMin,
                weight: FontWeight.w500,
                textColor: AppColors.textColor3,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MText(
                inputText: '$kva',
                size: 56.spMin,
                weight: FontWeight.w800,
                textColor: AppColors.primary,
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: MText(
                  inputText: 'kVA',
                  size: 18.spMin,
                  weight: FontWeight.w700,
                  textColor: AppColors.textColor,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          MText(
            inputText: 'Recommended inverter',
            size: 15.spMin,
            weight: FontWeight.w400,
            textColor: AppColors.textColor2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}