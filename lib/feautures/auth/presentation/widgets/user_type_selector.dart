import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/core/widgets/option_radio_tile.dart';

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector({super.key, required this.value, required this.onChanged});

  final String? value;
  final void Function(String) onChanged;

  // Backend values for `userType` aren't documented as an enum in the API
  // spec — these keys are a best guess and may need to match whatever the
  // server actually expects.
  static const options = {
    'HOMEOWNER_RENTER': 'Homeowner / Renter',
    'SMALL_BUSINESS_OWNER': 'Small Business Owner',
    'SOLAR_INSTALLER_TECHNICIAN': 'Solar Installer / Technician',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in options.entries) ...[
          OptionRadioTile(
            label: entry.value,
            selected: value == entry.key,
            onTap: () => onChanged(entry.key),
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
