import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/repos/delivery_fee_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class DeliveryFeePageController extends GetxController {
  final DeliveryFeeRepo deliveryFeeRepo = Get.find<DeliveryFeeRepo>();
  TextEditingController feeController = TextEditingController(text: "0");
  final loadingState = LoadingState.idle.obs;
  RxInt deliveryFee = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchDeliveryFee();
    feeController = TextEditingController(text: deliveryFee.value.toString());
  }

  Future<void> fetchDeliveryFee() async {
    final response = await deliveryFeeRepo.getDeliveryFee();

    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    deliveryFee.value = response.data?.fee != null
        ? double.parse(response.data!.fee).toInt()
        : 0;

    loadingState.value = LoadingState.doneWithData;
  }

  Future<void> updateDeliveryFee() async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;

    final fee = double.tryParse(feeController.text.trim());
    if (fee == null) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: 'InvalidFeeFormat'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }

    final response = await deliveryFeeRepo.updateDeliveryFee(fee);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    deliveryFee.value = fee.toInt();
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'DeliveryFeeUpdated'.tr,
      type: CustomToastType.success,
    ).show();
    Get.back();
  }

  bool _validateForm() {
    if (feeController.text.trim().isEmpty) {
      CustomToasts(
        message: 'FeeRequired'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    if (double.tryParse(feeController.text.trim()) == null) {
      CustomToasts(
        message: 'InvalidFeeFormat'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    return true;
  }

  void clearForm() {
    feeController.clear();
  }

  @override
  void onClose() {
    feeController.dispose();
    super.onClose();
  }
}
