import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/repos/orders_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  late int orderId;
  final order = Rxn<OrderModel>();
  final loadingState = LoadingState.doneWithData.obs;

  @override
  void onInit() {
    super.onInit();
    order.value = Get.arguments;
    orderId = order.value!.orderId;
  }

  Future<void> cancelOrder() async {
    loadingState.value = LoadingState.loading;
    final response = await orderRepo.cancelOrder(orderId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'OrderCancelled'.tr,
      type: CustomToastType.success,
    ).show();
  }

  void showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        title: Text(
          'CancelOrder'.tr,
          style: TextStyle(
            fontSize: FontSize.s16,
            fontWeight: FontWeight.w600,
            color: ColorManager.colorFontPrimary,
          ),
        ),
        content: Text(
          'CancelOrderPrompt'.tr,
          style: TextStyle(
            fontSize: FontSize.s14,
            color: ColorManager.colorDoveGray600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorDoveGray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await cancelOrder();
            },
            child: Text(
              'Yes'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
