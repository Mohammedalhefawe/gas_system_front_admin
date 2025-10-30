import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/customer_model.dart';
import 'package:gas_admin_app/data/repos/customer_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class CustomersPageController extends GetxController {
  final CustomersRepo customersRepo = Get.find<CustomersRepo>();
  final customers = <CustomerModel>[].obs;
  final loadingState = LoadingState.idle.obs;
  final loadingMoreCustomersState = LoadingState.idle.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final hasMorePages = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCustomers(page: 1);
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
      loadMoreCustomers();
    }
  }

  Future<void> fetchCustomers({required int page, int perPage = 10}) async {
    if (loadingState.value == LoadingState.loading) return;
    loadingState.value = LoadingState.loading;

    final response = await customersRepo.getCustomers(
      page: page,
      perPage: perPage,
    );
    if (!response.success || response.data == null) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    if (page == 1) {
      customers.clear();
    }
    customers.addAll(response.data!.data);
    currentPage.value = response.data!.currentPage;
    lastPage.value = response.data!.lastPage;
    hasMorePages.value = currentPage.value < lastPage.value;

    loadingState.value = customers.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> loadMoreCustomers() async {
    if (loadingMoreCustomersState.value == LoadingState.loading ||
        !hasMorePages.value) {
      return;
    }

    loadingMoreCustomersState.value = LoadingState.loading;

    final nextPage = currentPage.value + 1;
    final response = await customersRepo.getCustomers(page: nextPage);

    if (!response.success || response.data == null) {
      loadingMoreCustomersState.value = LoadingState.hasError;
      return;
    }

    customers.addAll(response.data!.data);
    currentPage.value = response.data!.currentPage;
    lastPage.value = response.data!.lastPage;
    hasMorePages.value = currentPage.value < lastPage.value;

    loadingMoreCustomersState.value = LoadingState.doneWithData;
  }

  Future<void> refreshCustomers() async {
    customers.clear();
    currentPage.value = 1;
    lastPage.value = 1;
    hasMorePages.value = false;
    loadingState.value = LoadingState.idle;
    loadingMoreCustomersState.value = LoadingState.idle;
    await fetchCustomers(page: 1);
  }

  Future<void> toggleBlockCustomer(int customerId, bool isBlocked) async {
    loadingState.value = LoadingState.loading;
    final response = await customersRepo.toggleBlockDriver(customerId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    final index = customers.indexWhere((d) => d.customerId == customerId);
    if (index >= 0) {
      customers[index] = customers[index].copyWith(
        blocked: !customers[index].blocked,
      );
    }
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message:
          response.successMessage ??
          (isBlocked ? 'DriverUnblocked'.tr : 'DriverBlocked'.tr),
      type: CustomToastType.success,
    ).show();
  }
}
