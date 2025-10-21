import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/pages/auth/registration_page/registration_page_controller.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';

class AgreementText extends GetView<RegistrationPageController> {
  const AgreementText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Get.textTheme.bodySmall,
          children: [
            TextSpan(text: "SraseUser".tr),
            TextSpan(
              text: '\n${'TermsofUse'.tr}',
              style: Get.textTheme.bodySmall?.copyWith(
                color: ColorManager.colorPrimary,
              ),
              recognizer: TapGestureRecognizer()..onTap = controller.termsOfUse,
            ),
            const TextSpan(text: ' و '),
            TextSpan(
              text: 'PrivacyPolicy'.tr,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorPrimary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = controller.privacyPolicy,
            ),
          ],
        ),
      ),
    );
  }
}
