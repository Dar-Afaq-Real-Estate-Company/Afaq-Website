import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/constants_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../dashboard/ui/widgets/build_action_button.dart';
import 'dart:ui' as ui;

// --- Main About Us Screen Widget ---
class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppStrings.aboutUs.tr()),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0.h),
        children: <Widget>[
          const AppIdentitySection(),
          Divider(height: 30.h, thickness: 1),
          const MissionSection(),
          Divider(height: 30.h, thickness: 1),
          const ContactSection(),
          Divider(height: 20.h, thickness: 1),
        ],
      ),
    );
  }
}

class AppIdentitySection extends StatelessWidget {
  const AppIdentitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/images/splash_image.jpg',
          width: 70.w,
          height: 70.h,
        ),
        verticalSpace(5),
        Align(
          alignment: Alignment.centerRight,
          child: SectionHeader(title: AppStrings.appName.tr()),
        ),
        verticalSpace(8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            AppStrings.appIdentityDesc.tr(),
            style: StylesManager.font13Grey
                .copyWith(fontSize: 16.sp, color: Colors.black, height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        verticalSpace(10)
      ],
    );
  }
}

class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: AppStrings.whoWeAre.tr()),
        verticalSpace(10),
        Text(
          AppStrings.whoWeAreDesc.tr(),
          style: StylesManager.font13Grey
              .copyWith(fontSize: 16.sp, color: Colors.black, height: 1.3),
          textAlign: TextAlign.start,
        ),
        Divider(height: 30.h, thickness: 1),
        SectionHeader(title: AppStrings.ourValues.tr()),
        verticalSpace(10),
        LabeledInfo(
          icon: Icons.check_circle_outline,
          text: AppStrings.valuePartner.tr(),
        ),
        LabeledInfo(
          icon: Icons.people_outline,
          text: AppStrings.valueProjects.tr(),
        ),
        LabeledInfo(
          icon: Icons.rocket_launch_outlined,
          text: AppStrings.valueInnovation.tr(),
        ),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Directionality(
          textDirection: context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: SectionHeader(title: AppStrings.contactUs.tr()),
        ),
        verticalSpace(10),
        ListTile(
          leading: Icon(Icons.email, color: ColorManager.primary),
          title: const Text(AppConstants.companyEmail),
          onTap: () {
            launchURL('afaqkw.app@gmail.com');
          },
        ),
        ListTile(
          leading: Icon(Icons.language, color: ColorManager.primary),
          title: const Text(AppConstants.companyWebSite),
          onTap: () {
            launchURL('https://api.afaq.group/');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.call,
            color: ColorManager.primary,
          ),
          title: Text(
            AppConstants.afaqPhoneNumber,
            textDirection: ui.TextDirection.ltr,
            textAlign: context.locale.languageCode == 'ar'
                ? TextAlign.right
                : TextAlign.left,
          ),
          onTap: () {
            makePhoneCall(AppConstants.afaqPhoneNumber);
          },
        ),
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.whatsapp,
            color: ColorManager.primary,
          ),
          title: Text(
            AppConstants.afaqPhoneNumber,
            textDirection: ui.TextDirection.ltr,
            textAlign: context.locale.languageCode == 'ar'
                ? TextAlign.right
                : TextAlign.left,
          ),
          onTap: () {
            launchWhatsAppAd(
              context,
              phone: AppConstants.afaqPhoneNumber,
              adId: "",
            );
          },
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
      ),
    );
  }
}

class LabeledInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const LabeledInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 19.sp, color: ColorManager.primary),
          horizontalSpace(10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
