import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoBanner extends StatelessWidget {
  final String text;
  final String? svgPath;

  const InfoBanner({super.key, required this.text, this.svgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0x14E87A2D),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color:  Color(0x33E87A2D),
          width: 1.22.spMin,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          svgPath != null
              ? SvgPicture.asset(
            svgPath!,
            width: 24.w,
            height: 24.w,
          )
              : Icon(

            Icons.wb_sunny_outlined,
            color: Colors.orange,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color:  Color(0xff804319),
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}