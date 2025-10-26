import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/customer_model.dart';
import 'package:gas_admin_app/data/repos/customer_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class CustomersPageController extends GetxController {
  final CustomersRepo customersRepo = Get.find<CustomersRepo>();
  final customers = <CustomerModel>[].obs;
  final loadingState = LoadingState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    loadingState.value = LoadingState.loading;
    final response = await customersRepo.getCustomers();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    customers.value = response.data ?? [];
    loadingState.value = customers.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
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
