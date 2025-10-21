import 'package:flutter/material.dart';
import 'package:gas_admin_app/core/services/cache_service.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/address_model.dart';
import 'package:gas_admin_app/data/repos/orders_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/pages/address_page/address_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/address_page/select_location_page.dart';
import 'package:gas_admin_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddOrderPageController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  final CacheService cacheService = Get.find<CacheService>();
  final CartController cartController = Get.find<CartController>();
  AddressListController? addressListController;
  final addresses = <AddressModel>[].obs;
  final selectedAddress = Rxn<AddressModel>();
  final loadingState = LoadingState.idle.obs;
  final isImmediate = true.obs;
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final noteController = TextEditingController();
  final paymentMethod = 'cash'.obs;
  final addressPopupMenuKey = GlobalKey<PopupMenuButtonState>();
  final paymentPopupMenuKey = GlobalKey<PopupMenuButtonState>();

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<AddressListController>()) {
      Get.put(AddressListController());
    }
    addressListController = Get.find<AddressListController>();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    loadingState.value = LoadingState.loading;
    await addressListController?.fetchAddresses();
    addresses.value = addressListController?.addresses ?? [];
    loadingState.value = addresses.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  void selectPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final time = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      timeController.text = DateFormat('HH:mm').format(time);
    }
  }

  Future<void> submitOrder() async {
    if (loadingState.value == LoadingState.loading) return;

    if (selectedAddress.value == null) {
      CustomToasts(
        message: 'RequiredAddress'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }

    if (!isImmediate.value) {
      if (dateController.text.isEmpty) {
        CustomToasts(
          message: 'RequiredDate'.tr,
          type: CustomToastType.error,
        ).show();
        return;
      }
      if (timeController.text.isEmpty) {
        CustomToasts(
          message: 'RequiredTime'.tr,
          type: CustomToastType.error,
        ).show();
        return;
      }
    }

    final orderData = {
      'items': cartController.cartItems
          .map(
            (item) => {
              'product_id': item.product.id,
              'quantity': item.quantity,
            },
          )
          .toList(),
      'address_id': selectedAddress.value!.addressId,
      'payment_method': paymentMethod.value,
      'delivery_date': isImmediate.value ? null : dateController.text,
      'delivery_time': isImmediate.value ? null : timeController.text,
      'immediate': isImmediate.value,
      'note': noteController.text.trim().isNotEmpty
          ? noteController.text.trim()
          : null,
    };

    loadingState.value = LoadingState.loading;
    final response = await orderRepo.createOrder(orderData);

    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    cartController.clearCart();
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'OrderPlaced'.tr,
      type: CustomToastType.success,
    ).show();
    Get.back();
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    noteController.dispose();
    super.onClose();
  }

  addNewAddress() async {
    await addressListController?.setAddress(StatusLocation.add);
    loadingState.value = LoadingState.loading;
    await fetchAddresses();
    loadingState.value = addresses.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }
}
