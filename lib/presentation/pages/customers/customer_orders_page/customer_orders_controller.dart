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

  CustomerOrdersController({this.customerId});

  @override
  void onInit() {
    super.onInit();

    fetchCustomerOrders();
  }

  Future<void> fetchCustomerOrders() async {
    myOrdersLoadingState.value = LoadingState.loading;
    final response = await customersRepo.getCustomerOrders(customerId!);
    if (!response.success) {
      myOrdersLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    myOrders.value = response.data ?? [];
    myOrdersLoadingState.value = myOrders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }
}
