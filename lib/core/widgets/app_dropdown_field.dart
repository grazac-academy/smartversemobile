import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme/app_colors.dart';

class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final List<String> options;
  final String? value;
  final void Function(String) onChanged;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DropdownOptionsSheet(title: label, options: options),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.black)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _openPicker(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(fontSize: 14.sp, color: value != null ? AppColors.black : Colors.grey.shade500),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownOptionsSheet extends StatelessWidget {
  const _DropdownOptionsSheet({required this.title, required this.options});

  final String title;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 420.h,
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Text("Select $title", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            const Divider(height: 24),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ListTile(
                  title: Text(options[i]),
                  onTap: () => Navigator.pop(context, options[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
