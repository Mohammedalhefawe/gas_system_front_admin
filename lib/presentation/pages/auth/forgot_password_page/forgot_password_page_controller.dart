import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/core/services/cache_service.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/repos/users_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';

class ForgotPasswordPageController extends GetxController {
  CacheService cacheService = Get.find<CacheService>();
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final countryCode = "+963".obs;
  final formattedMobileNumber = ''.obs;
  final requestPinLoadingState = LoadingState.idle.obs;

  String get fullNumber =>
      "${countryCode.value}${sanitizePhoneNumber(formattedMobileNumber.value)}";

  Future requestPin() async {
    if (!formKey.currentState!.validate()) return;

    if (!GetUtils.isPhoneNumber(fullNumber)) {
      CustomToasts(
        message: "RequiredPhoneNumber".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }

    if (requestPinLoadingState.value == LoadingState.loading) return;
    requestPinLoadingState.value = LoadingState.loading;

    final response = await usersRepo.forgetPassword(
      phoneNumber: fullNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
    );

    if (!response.success) {
      requestPinLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    CustomToasts(
      message: response.successMessage ?? "ResetPinSuccess".tr,
      type: CustomToastType.success,
    ).show();

    Get.toNamed(
      AppRoutes.verifyResetPinRoute,
      arguments: {'phoneNumber': fullNumber},
    );

    requestPinLoadingState.value = LoadingState.doneWithData;
  }

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
