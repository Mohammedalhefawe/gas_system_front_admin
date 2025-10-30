import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/repos/customer_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class CustomerOrdersController extends GetxController {
  final CustomersRepo customersRepo = Get.find<CustomersRepo>();
  final int? customerId;
  final myOrders = <OrderModel>[].obs;
  final myOrdersLoadingState = LoadingState.idle.obs;
  final loadingMoreOrdersState = LoadingState.idle.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final hasMorePages = false.obs;
  final ScrollController scrollController = ScrollController();

  CustomerOrdersController({this.customerId});

  @override
  void onInit() {
    super.onInit();
    fetchCustomerOrders(page: 1);
    scrollController.addListener(scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      loadMoreOrders();
    }
  }

  Future<void> fetchCustomerOrders({
    required int page,
    int pageSize = 10,
  }) async {
    if (myOrdersLoadingState.value == LoadingState.loading) return;
    myOrdersLoadingState.value = LoadingState.loading;

    final response = await customersRepo.getCustomerOrders(
      customerId!,
      page: page,
      pageSize: pageSize,
    );
    if (!response.success || response.data == null) {
      myOrdersLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    if (page == 1) {
      myOrders.clear();
    }
    myOrders.addAll(response.data!.data);
    currentPage.value = response.data!.currentPage;
    lastPage.value = response.data!.lastPage;
    hasMorePages.value = currentPage.value < lastPage.value;

    myOrdersLoadingState.value = myOrders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> loadMoreOrders() async {
    if (loadingMoreOrdersState.value == LoadingState.loading ||
        !hasMorePages.value) {
      return;
    }

    loadingMoreOrdersState.value = LoadingState.loading;

    final nextPage = currentPage.value + 1;
    final response = await customersRepo.getCustomerOrders(
      customerId!,
      page: nextPage,
    );

    if (!response.success || response.data == null) {
      loadingMoreOrdersState.value = LoadingState.hasError;
      return;
    }

    myOrders.addAll(response.data!.data);
    currentPage.value = response.data!.currentPage;
    lastPage.value = response.data!.lastPage;
    hasMorePages.value = currentPage.value < lastPage.value;

    loadingMoreOrdersState.value = LoadingState.doneWithData;
  }

  Future<void> refreshCustomerOrders() async {
    myOrders.clear();
    currentPage.value = 1;
    lastPage.value = 1;
    hasMorePages.value = false;
    myOrdersLoadingState.value = LoadingState.idle;
    loadingMoreOrdersState.value = LoadingState.idle;
    await fetchCustomerOrders(page: 1);
  }
}
