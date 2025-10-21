import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/pages/auth/verification_page/widgets/pininput_custom.dart';
import 'package:gas_admin_app/presentation/pages/auth/widgets/auth_app_bar.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';

import 'verification_page_controller.dart';

class VerificationPage extends GetView<VerificationPageController> {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AuthAppBar(
                title: "TitleVerification".tr,
                subTitle: "SubtitleVerification".tr,
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p14),
                child: Column(
                  children: [
                    InputVerification(),
                    SizedBox(height: AppSize.s24),
                    Obx(() {
                      return AppButton(
                        loadingMode:
                            controller.verificationLoadingState.value ==
                            LoadingState.loading,
                        onPressed: controller.next,
                        backgroundColor: ColorManager.colorPrimary,
                        text: 'next'.tr,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputVerification extends GetView<VerificationPageController> {
  const InputVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.p12),
      width: AppSize.sWidth,
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.12),
            offset: Offset(0, 2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PinPutCustom(
            controller: controller.codeController,
            onCompleted: (_) {
              controller.next();
            },
          ),
          SizedBox(height: AppSize.s24),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "resendCodeIn".tr,
                  style: TextStyle(
                    color: ColorManager.colorGrey5,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(width: AppSize.s10),
                Text(
                  controller.timerText,
                  style: TextStyle(
                    color: ColorManager.colorGrey5,
                    fontSize: FontSize.s12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.remainingTime.value == 0
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        controller.resendCode();
                      },
                      child: Text(
                        "resendCode".tr,
                        style: TextStyle(
                          color: ColorManager.colorPrimary,
                          fontSize: FontSize.s13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
