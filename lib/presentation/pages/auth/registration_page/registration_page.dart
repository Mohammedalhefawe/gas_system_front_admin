import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/pages/auth/registration_page/registration_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/auth/registration_page/widgets/agreement_text.dart';
import 'package:gas_admin_app/presentation/pages/auth/registration_page/widgets/info_card.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/pages/auth/widgets/auth_app_bar.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/phone_number_widget.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class RegistrationPage extends GetView<RegistrationPageController> {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: F,
      child: Scaffold(
        backgroundColor: ColorManager.colorBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AuthAppBar(
                title: "TitleRegistrationPage".tr,
                subTitle: "SubtitleRegistrationPage".tr,
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Column(
                  children: [
                    InputRegistration(),
                    SizedBox(height: AppSize.s24),
                    Obx(
                      () => AppButton(
                        onPressed: () {
                          controller.next();
                        },
                        backgroundColor: ColorManager.colorPrimary,
                        text: 'next'.tr,
                        loadingMode:
                            controller.registerLoadingState.value ==
                            LoadingState.loading,
                      ),
                    ),
                    SizedBox(height: AppSize.s12),
                    AgreementText(),
                    SizedBox(height: AppSize.s24),
                    InfoCard(),
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

class InputRegistration extends GetView<RegistrationPageController> {
  const InputRegistration({super.key});

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
            CustomTextField(
              requiredField: true,
              title: "fullName".tr,
              hint: "${"type".tr} ${"fullName".tr}",
              textEditingController: controller.fullNameController,
              textInputType: TextInputType.text,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              icon: Assets.icons.userIcon.svg(width: AppSize.s28),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "RequiredFullName".tr;
                }
                return null;
              },
            ),
            SizedBox(height: AppSize.s14),
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
                if (value!.isEmpty ||
                    !GetUtils.isPhoneNumber(value.trim().replaceAll(" ", ""))) {
                  return "RequiredPhoneNumber".tr;
                }
                return null;
              },
            ),
            SizedBox(height: AppSize.s14),
            Obx(
              () => CustomTextField(
                requiredField: true,
                title: "password".tr,
                hint: "enterPassword".tr,
                icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                textEditingController: controller.passwordController,
                obscureText: !controller.isPassword.value,
                suffixIcon: GestureDetector(
                  onTap: () {
                    controller.isPassword.value = !controller.isPassword.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p8,
                    ),
                    child: controller.isPassword.value
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
                    return "RequiredPassword".tr;
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
                title: "passwordConfirmation".tr,
                hint: "EnterConfirmationPassword".tr,
                icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                textEditingController:
                    controller.passwordConfirmationController,
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
                    return "RequiredPasswordConfirmation".tr;
                  }
                  if (value != controller.passwordController.text) {
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
