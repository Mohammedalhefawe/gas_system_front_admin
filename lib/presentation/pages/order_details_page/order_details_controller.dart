import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/repos/orders_repo.dart';
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
}
