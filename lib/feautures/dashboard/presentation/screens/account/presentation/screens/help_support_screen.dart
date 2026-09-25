import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/core/widgets/app_bar_icon.dart';
import '../widgets/contact_item_card.dart';
import '../widgets/faq_item.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
                    "HELP & SUPPORT",
                    style: TextStyle(
                      color: AppColors.appliancestext,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Text("CONTACT US", style: _sectionTitleStyle()),
              SizedBox(height: 4.h),
              ContactItemCard(
                svgPath: "assets/icons/mail_regular.svg",
                 title: "Email us",
                value: "support@smartvert.ng",
                subtitle: "We reply within 24 hours",
                iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                iconColor: AppColors.primary,
              ),
              ContactItemCard(
               svgPath: "assets/icons/whatsapp_original.svg",
                title: "WhatsApp",
                value: "+234 800 SMARTVERT",
                subtitle: "Mon - Fri, 9am - 5pm WAT",
                iconBgColor: AppColors.successGreen.withValues(alpha: 0.1),
                iconColor: AppColors.successGreen,
              ),
              ContactItemCard(
                svgPath: "assets/icons/whatsapp_original.svg",
                title: "WhatsApp",
                value: "+234 800 SMARTVERT",
                subtitle: "Mon - Fri, 9am - 5pm WAT",
                iconBgColor: AppColors.successGreen.withValues(alpha: 0.1),
                iconColor: AppColors.successGreen,
              ),
              SizedBox(height: 32.h),
              Text("FREQUENTLY ASKED QUESTIONS", style: _sectionTitleStyle()),
              SizedBox(height: 77.h),
              FaqItem(question: "How does SmartVert calculate my solar system size?", answer: "SmartVert adds up the wattage of all your selected appliances, applies a 25% safety margin and accounts for surge loads (like fridges and ACs that draw 3–5× their running wattage at startup). It then factors in your daily usage hours to determine battery capacity and solar panel needs."),
              FaqItem(question: "What is the difference between Backup mode and Off-grid mode?", answer: "SmartVert adds up the wattage of all your selected appliances, applies a 25% safety margin and accounts for surge loads (like fridges and ACs that draw 3–5× their running wattage at startup). It then factors in your daily usage hours to determine battery capacity and solar panel needs.",),
              FaqItem(question: "Why is my inverter size larger than I expected?", answer: "Backup mode assumes you still have grid power part of the time and sizes your system to cover outages. Off-grid mode sizes a system that can run entirely without grid power — it recommends larger batteries and more solar panels.",),
              FaqItem(question: "How does SmartVert calculate my solar system size?", answer: "Inverter size is based on your peak load, not average load. Heavy appliances like fridges, ACs, and pumps have a startup surge that can be 3–5× their running wattage. The inverter must handle this peak, not just steady-state consumption.",),
              FaqItem(question: "Is SmartVert free to use?" , answer: "Yes. Basic solar sizing is free. Create an account to save and access your sizing results anytime.",),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(
      color: AppColors.appliancestext,
      fontSize: 11.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    );
  }
}
