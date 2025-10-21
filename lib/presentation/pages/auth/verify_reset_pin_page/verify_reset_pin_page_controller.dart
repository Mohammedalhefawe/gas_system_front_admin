import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/repos/users_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';

class VerifyResetPinPageController extends GetxController {
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final verifyPinLoadingState = LoadingState.idle.obs;
  final resendPinLoadingState = LoadingState.idle.obs;
  final pinController = TextEditingController();

  final remainingTime = 120.obs;
  late Timer _timer;

  String? phoneNumber = Get.arguments['phoneNumber'];

  @override
  void onInit() {
    _startTimer();
    super.onInit();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value == 0) {
        timer.cancel();
      } else {
        remainingTime.value--;
      }
    });
  }

  void _resetTimer() {
    remainingTime.value = 120;
    _startTimer();
  }

  String get timerText {
    final minutes = (remainingTime.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  Future verifyPin() async {
    if (verifyPinLoadingState.value == LoadingState.loading) return;
    verifyPinLoadingState.value = LoadingState.loading;

    final response = await usersRepo.verifyResetPin(
      phoneNumber: phoneNumber?.replaceAll(RegExp(r'[^0-9+]'), '') ?? '',
      pin: pinController.text,
    );

    if (!response.success) {
      verifyPinLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    CustomToasts(
      message: response.successMessage ?? 'VerifyResetPinSuccess'.tr,
      type: CustomToastType.success,
    ).show();

    Get.toNamed(
      AppRoutes.resetPasswordRoute,
      arguments: {'phoneNumber': phoneNumber, 'pin': pinController.text},
    );

    verifyPinLoadingState.value = LoadingState.doneWithData;
  }

  Future resendPin() async {
    if (resendPinLoadingState.value == LoadingState.loading) return;
    resendPinLoadingState.value = LoadingState.loading;

    final response = await usersRepo.forgetPassword(
      phoneNumber: phoneNumber ?? '',
    );

    if (!response.success) {
      resendPinLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      remainingTime.value = 0;
      _timer.cancel();
      return;
    }

    CustomToasts(
      message: "ResendCodeSuccess".tr,
      type: CustomToastType.success,
    ).show();

    resendPinLoadingState.value = LoadingState.doneWithData;
    _resetTimer();
  }
}
