import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/drivers/drivers_page/drivers_page_controller.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/phone_number_widget.dart'
    show PhoneNumberInput;
import 'package:get/get.dart';

class AddDriverPage extends GetView<DriversPageController> {
  const AddDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorBackground,
        appBar: NormalAppBar(title: 'AddDriver'.tr, backIcon: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  requiredField: true,
                  title: 'FullName'.tr,
                  hint: 'EnterFullName'.tr,
                  textEditingController: controller.fullNameController,
                  textInputType: TextInputType.text,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'RequiredFullName'.tr
                      : null,
                ),
                const SizedBox(height: AppSize.s16),
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
                        !GetUtils.isPhoneNumber(
                          value.trim().replaceAll(" ", ""),
                        )) {
                      return "RequiredPhoneNumber".tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSize.s16),
                Obx(
                  () => CustomTextField(
                    requiredField: true,
                    title: 'Password'.tr,
                    hint: 'EnterPassword'.tr,
                    icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                    textEditingController: controller.passwordController,
                    obscureText: !controller.isPassword.value,
                    suffixIcon: GestureDetector(
                      onTap: () => controller.isPassword.value =
                          !controller.isPassword.value,
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
                        return 'RequiredPassword'.tr;
                      }
                      if (value.length < 6) {
                        return 'PasswordTooShort'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppSize.s16),
                Obx(
                  () => CustomTextField(
                    requiredField: true,
                    title: 'PasswordConfirmation'.tr,
                    hint: 'EnterConfirmationPassword'.tr,
                    icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                    textEditingController:
                        controller.passwordConfirmationController,
                    obscureText: !controller.isConfirmPassword.value,
                    suffixIcon: GestureDetector(
                      onTap: () => controller.isConfirmPassword.value =
                          !controller.isConfirmPassword.value,
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
                        return 'RequiredPasswordConfirmation'.tr;
                      }
                      if (value != controller.passwordController.text) {
                        return 'PasswordMismatch'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppSize.s16),
                CustomTextField(
                  requiredField: true,
                  title: 'VehicleType'.tr,
                  hint: 'EnterVehicleType'.tr,
                  textEditingController: controller.vehicleTypeController,
                  textInputType: TextInputType.text,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'RequiredVehicleType'.tr
                      : null,
                ),
                const SizedBox(height: AppSize.s16),
                CustomTextField(
                  requiredField: true,
                  title: 'LicenseNumber'.tr,
                  hint: 'EnterLicenseNumber'.tr,
                  textEditingController: controller.licenseNumberController,
                  textInputType: TextInputType.text,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'RequiredLicenseNumber'.tr
                      : null,
                ),
                const SizedBox(height: AppSize.s16),
                CustomTextField(
                  requiredField: true,
                  title: 'MaxCapacity'.tr,
                  hint: 'EnterMaxCapacity'.tr,
                  textEditingController: controller.maxCapacityController,
                  textInputType: TextInputType.number,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'RequiredMaxCapacity'.tr;
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'ValidMaxCapacityRequired'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSize.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      onPressed: () => Get.back(),
                      text: 'Cancel'.tr,
                      backgroundColor: ColorManager.colorWhite,
                      fontColor: ColorManager.colorDoveGray600,
                      border: Border.all(color: ColorManager.colorDoveGray600),
                    ),
                    const SizedBox(width: AppSize.s8),
                    AppButton(
                      onPressed: controller.addDriver,
                      text: 'Add'.tr,
                      backgroundColor: ColorManager.colorPrimary,
                      fontColor: ColorManager.colorWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
