import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/repos/driver_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class DriverOrdersController extends GetxController {
  final DriversRepo driversRepo = Get.find<DriversRepo>();
  final int? driverId; // Optional driverId for specific driver orders
  final myOrders = <OrderModel>[].obs;
  final newOrders = <OrderModel>[].obs;
  final myOrdersLoadingState = LoadingState.idle.obs;
  final currentTab = 0.obs;

  DriverOrdersController({this.driverId});

  @override
  void onInit() {
    super.onInit();
    if (driverId != null) {
      fetchDriverOrders();
    } else {
      fetchDriverOrders();
    }
  }

  Future<void> fetchDriverOrders() async {
    myOrdersLoadingState.value = LoadingState.loading;
    final response = await driversRepo.getDriverOrders(driverId!);
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
