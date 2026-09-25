import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? AppColors.successGreen
                    : AppColors.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isExpanded ? Icons.remove : Icons.add,
                color: _isExpanded ? AppColors.main : Color(0xff2D6B4A),
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question,
                      style: TextStyle(
                        color: AppColors.appliancestext,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    if (_isExpanded) ...[
                      SizedBox(height: 12.h),
                      Text(
                        widget.answer,
                        style: TextStyle(
                          color: Color(0xff6B7B74),
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}