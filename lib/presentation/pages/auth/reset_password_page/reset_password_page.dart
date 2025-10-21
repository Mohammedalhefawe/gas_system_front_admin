import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/pages/auth/widgets/auth_app_bar.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'reset_password_page_controller.dart';

class ResetPasswordPage extends GetView<ResetPasswordPageController> {
  const ResetPasswordPage({super.key});

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
                title: "TitleResetPassword".tr,
                subTitle: "SubtitleResetPassword".tr,
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Column(
                  children: [
                    InputResetPassword(),
                    SizedBox(height: AppSize.s24),
                    Obx(() {
                      return AppButton(
                        loadingMode:
                            controller.resetPasswordLoadingState.value ==
                            LoadingState.loading,
                        onPressed: controller.resetPassword,
                        backgroundColor: ColorManager.colorPrimary,
                        text: 'submit'.tr,
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

class InputResetPassword extends GetView<ResetPasswordPageController> {
  const InputResetPassword({super.key});

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
            Obx(
              () => CustomTextField(
                requiredField: true,
                title: "newPassword".tr,
                hint: "enterNewPassword".tr,
                icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                textEditingController: controller.newPasswordController,
                obscureText: !controller.isNewPassword.value,
                suffixIcon: GestureDetector(
                  onTap: () {
                    controller.isNewPassword.value =
                        !controller.isNewPassword.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p8,
                    ),
                    child: controller.isNewPassword.value
                        ? Assets.icons.eyeOpenIcon.svg()
                        : Assets.icons.eyeClosedIcon.svg(),
                  ),
                ),
                textInputType: TextInputType.visiblePassword,
                fillColor: ColorManager.colorWhite,
                borderRadius: AppSize.s8,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "RequiredNewPassword".tr;
                  }
                  if (value.length < 6) {
                    return "PasswordTooShort".tr;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: AppSize.s14),
            Obx(
              () => CustomTextField(
                requiredField: true,
                title: "newPasswordConfirmation".tr,
                hint: "enterNewPasswordConfirmation".tr,
                icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                textEditingController:
                    controller.newPasswordConfirmationController,
                obscureText: !controller.isConfirmPassword.value,
                suffixIcon: GestureDetector(
                  onTap: () {
                    controller.isConfirmPassword.value =
                        !controller.isConfirmPassword.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p8,
                    ),
                    child: controller.isConfirmPassword.value
                        ? Assets.icons.eyeOpenIcon.svg()
                        : Assets.icons.eyeClosedIcon.svg(),
                  ),
                ),
                textInputType: TextInputType.visiblePassword,
                fillColor: ColorManager.colorWhite,
                borderRadius: AppSize.s8,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "RequiredNewPasswordConfirmation".tr;
                  }
                  if (value != controller.newPasswordController.text) {
                    return "PasswordMismatch".tr;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
