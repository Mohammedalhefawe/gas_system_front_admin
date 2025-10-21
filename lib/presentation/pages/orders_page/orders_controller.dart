import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/repos/delivery_fee_repo.dart';
import 'package:gas_admin_app/data/repos/orders_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class OrdersPageController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  final DeliveryFeeRepo deliveryFeeRepo = Get.find<DeliveryFeeRepo>();
  final orders = <OrderModel>[].obs;
  final loadingState = LoadingState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    loadingState.value = LoadingState.loading;
    final response = await orderRepo.getOrders();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    orders.value = response.data ?? [];
    loadingState.value = orders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> cancelOrder(int orderId) async {
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
    await fetchOrders();
    CustomToasts(
      message: response.successMessage ?? 'OrderCancelled'.tr,
      type: CustomToastType.success,
    ).show();
  }

  void showCancelConfirmation(BuildContext context, int orderId) {
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
              await cancelOrder(orderId);
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
