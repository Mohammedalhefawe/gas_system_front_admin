import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/core/services/cache_service.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/repos/users_repo.dart';
import 'package:gas_admin_app/data/dto/register_dto.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';

class RegistrationPageController extends GetxController {
  CacheService cacheService = Get.find<CacheService>();
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final countryCode = "+963".obs;
  final formattedMobileNumber = ''.obs;
  final registerLoadingState = LoadingState.idle.obs;
  final isPassword = false.obs;
  final isConfirmPassword = false.obs;

  String get fullNumber =>
      "${countryCode.value}${sanitizePhoneNumber(formattedMobileNumber.value)}";

  Future next() async {
    if (!formKey.currentState!.validate()) return;

    if (!GetUtils.isPhoneNumber(fullNumber)) {
      CustomToasts(
        message: "RequiredPhoneNumber".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }

    // Prevent user duplicated press
    if (registerLoadingState.value == LoadingState.loading) return;
    registerLoadingState.value = LoadingState.loading;

    final registerDto = RegisterDto(
      fullName: fullNameController.text,
      phoneNumber: fullNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
    );

    final response = await usersRepo.register(registerDto: registerDto);

    if (!response.success) {
      registerLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    CustomToasts(
      message: response.successMessage ?? "RegistrationSuccessful".tr,
      type: CustomToastType.success,
    ).show();

    // Get.toNamed(
    //   AppRoutes.verificationRoute,
    //   arguments: {'phoneNumber': fullNumber},
    // );

    registerLoadingState.value = LoadingState.doneWithData;
  }

  void termsOfUse() {}

  void privacyPolicy() {}

  void selectPhoneNumber(String number) {
    formattedMobileNumber.value = number;
    debugPrint(fullNumber);
  }

  String sanitizePhoneNumber(String number) {
    if (countryCode.value == "+963" && number.startsWith("0")) {
      return number.substring(1);
    }
    return number;
  }
}
