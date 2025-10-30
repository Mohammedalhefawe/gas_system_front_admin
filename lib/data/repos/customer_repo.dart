import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/customer_model.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/models/paginated_model.dart';

import 'package:get/get.dart';

class CustomersRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<PaginatedModel<CustomerModel>>> getCustomers({
    int page = 1,
    int perPage = 10,
  }) async {
    AppResponse<PaginatedModel<CustomerModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: Api.customers,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      appResponse.success = true;
      appResponse.data = PaginatedModel<CustomerModel>.fromJson(
        response.data,
        (item) => CustomerModel.fromJson(item),
      );

      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }

    return appResponse;
  }

  Future<AppResponse<CustomerModel>> toggleBlockDriver(int customerId) async {
    AppResponse<CustomerModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.customers}/$customerId/toggle-block',
        method: Method.patch,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'customer block status updated';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<PaginatedModel<OrderModel>>> getCustomerOrders(
    int customerId, {
    required int page,
    int pageSize = 10,
  }) async {
    AppResponse<PaginatedModel<OrderModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: '${Api.customers}/$customerId/orders',
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
