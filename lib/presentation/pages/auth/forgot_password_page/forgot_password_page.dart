import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/pages/auth/widgets/auth_app_bar.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/phone_number_widget.dart';
import 'forgot_password_page_controller.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordPageController> {
  const ForgotPasswordPage({super.key});

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
                title: "TitleForgotPassword".tr,
                subTitle: "SubtitleForgotPassword".tr,
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Column(
                  children: [
                    InputForgotPassword(),
                    SizedBox(height: AppSize.s24),
                    Obx(() {
                      return AppButton(
                        loadingMode:
                            controller.requestPinLoadingState.value ==
                            LoadingState.loading,
                        onPressed: controller.requestPin,
                        backgroundColor: ColorManager.colorPrimary,
                        text: 'next'.tr,
                      );
                    }),
                    SizedBox(height: AppSize.s12),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.loginRoute);
                      },
                      child: Text(
                        "backToLogin".tr,
                        style: TextStyle(
                          color: ColorManager.colorPrimary,
                          fontSize: FontSize.s13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

class InputForgotPassword extends GetView<ForgotPasswordPageController> {
  const InputForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        padding: EdgeInsets.all(AppPadding.p14),
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
            PhoneNumberInput(
              title: "numberPhone".tr,
              borderRadius: AppSize.s8,
              textEditingController: controller.phoneNumberController,
              hintText: "${"type".tr} ${"numberPhone".tr}",
              readOnly: false,
              onChanged: (String number) {
                controller.selectPhoneNumber(number);
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty || !GetUtils.isPhoneNumber(value)) {
                  return "RequiredPhoneNumber".tr;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
