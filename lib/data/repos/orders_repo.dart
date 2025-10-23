import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:get/get.dart';

class OrderRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<List<OrderModel>>> getOrders() async {
    AppResponse<List<OrderModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.myOrders,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['orders'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
