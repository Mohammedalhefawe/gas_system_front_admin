import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/repos/users_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';

class VerificationPageController extends GetxController {
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final verificationLoadingState = LoadingState.idle.obs;
  final resendLoadingState = LoadingState.idle.obs;
  final codeController = TextEditingController();

  final remainingTime = 120.obs;
  late Timer _timer;

  String? phoneNumber = Get.arguments['phoneNumber'];
  String? typeOTP = Get.arguments['typeOTP'];

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

  Future next() async {
    if (codeController.text.isEmpty) {
      CustomToasts(
        message: "PleaseEnterCode".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }
    if (codeController.text.length < 6) {
      CustomToasts(
        message: "PleaseEnterValidCode".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }

    if (verificationLoadingState.value == LoadingState.loading) return;
    verificationLoadingState.value = LoadingState.loading;

    final response = await usersRepo.verifyOTP(
      phoneNumber: phoneNumber?.replaceAll(RegExp(r'[^0-9+]'), '') ?? "",
      pin: codeController.text,
    );

    if (!response.success) {
      verificationLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    CustomToasts(
      message: response.successMessage ?? 'VerificationSuccess'.tr,
      type: CustomToastType.success,
    ).show();

    if (typeOTP == "phone") {
      Get.offAllNamed(
        AppRoutes.mainRoute,
      ); // Navigate to main route after successful registration
    } else {
      Get.offNamed(AppRoutes.forgotPasswordRoute); // Navigate to password reset
    }

    verificationLoadingState.value = LoadingState.doneWithData;
  }

  Future resendCode() async {
    if (resendLoadingState.value == LoadingState.loading) return;
    resendLoadingState.value = LoadingState.loading;

    final response = await usersRepo.resendPin(phoneNumber: phoneNumber ?? '');

    if (!response.success) {
      resendLoadingState.value = LoadingState.hasError;
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

    resendLoadingState.value = LoadingState.doneWithData;
    _resetTimer();
  }
}
