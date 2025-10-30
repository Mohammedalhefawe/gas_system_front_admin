import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/models/paginated_model.dart';
import 'package:get/get.dart';

class OrderRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<PaginatedModel<OrderModel>>> getOrders({
    required int page,
    int pageSize = 10,
  }) async {
    AppResponse<PaginatedModel<OrderModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: Api.orders,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': pageSize},
      );
      appResponse.success = true;
      appResponse.data = PaginatedModel<OrderModel>.fromJson(
        response.data ?? {},
        (e) => OrderModel.fromJson(e),
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
