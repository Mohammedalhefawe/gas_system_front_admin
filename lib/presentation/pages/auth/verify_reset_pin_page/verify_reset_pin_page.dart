import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/pages/auth/verification_page/widgets/pininput_custom.dart';
import 'package:gas_admin_app/presentation/pages/auth/widgets/auth_app_bar.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'verify_reset_pin_page_controller.dart';

class VerifyResetPinPage extends GetView<VerifyResetPinPageController> {
  const VerifyResetPinPage({super.key});

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
                title: "TitleVerifyResetPin".tr,
                subTitle: "SubtitleVerifyResetPin".tr,
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p14),
                child: Column(
                  children: [
                    InputVerifyResetPin(),
                    SizedBox(height: AppSize.s24),
                    Obx(() {
                      return AppButton(
                        loadingMode:
                            controller.verifyPinLoadingState.value ==
                            LoadingState.loading,
                        onPressed: controller.verifyPin,
                        backgroundColor: ColorManager.colorPrimary,
                        text: 'next'.tr,
                      );
                    }),
                    SizedBox(height: AppSize.s12),
                    Obx(
                      () => controller.remainingTime.value == 0
                          ? Center(
                              child: TextButton(
                                onPressed: () {
                                  controller.resendPin();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputVerifyResetPin extends GetView<VerifyResetPinPageController> {
  const InputVerifyResetPin({super.key});

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
            controller: controller.pinController,
            onCompleted: (_) {
              controller.verifyPin();
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
        ],
      ),
    );
  }
}
