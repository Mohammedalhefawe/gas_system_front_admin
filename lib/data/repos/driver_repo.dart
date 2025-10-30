import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/driver_model.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/data/models/paginated_model.dart';

import 'package:get/get.dart';

class DriversRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<PaginatedModel<DriverModel>>> getDrivers({
    int page = 1,
    int perPage = 10,
  }) async {
    AppResponse<PaginatedModel<DriverModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: Api.drivers,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      appResponse.success = true;
      appResponse.data = PaginatedModel<DriverModel>.fromJson(
        response.data,
        (item) => DriverModel.fromJson(item),
      );

      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }

    return appResponse;
  }

  Future<AppResponse<DriverModel>> addDriver(
    Map<String, dynamic> driverData,
  ) async {
    AppResponse<DriverModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.register,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
        params: driverData,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Driver added successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<DriverModel>> toggleBlockDriver(int driverId) async {
    AppResponse<DriverModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.drivers}/$driverId/toggle-block',
        method: Method.patch,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Driver block status updated';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<PaginatedModel<OrderModel>>> getDriverOrders(
    int driverId, {
    int page = 1,
    int perPage = 10,
  }) async {
    AppResponse<PaginatedModel<OrderModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: '${Api.drivers}/$driverId/orders',
        method: Method.get,
        requiredToken: true,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      appResponse.success = true;
      appResponse.data = PaginatedModel<OrderModel>.fromJson(
        response.data,
        (item) => OrderModel.fromJson(item),
      );

      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }

    return appResponse;
  }
}
