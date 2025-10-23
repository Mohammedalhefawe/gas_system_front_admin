import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/driver_model.dart';
import 'package:gas_admin_app/data/models/order_model.dart';

import 'package:get/get.dart';

class DriversRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<List<DriverModel>>> getDrivers() async {
    AppResponse<List<DriverModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.drivers,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['drivers'] as List<dynamic>?)
          ?.map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList();
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

  Future<AppResponse<List<OrderModel>>> getDriverOrders(int driverId) async {
    AppResponse<List<OrderModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.drivers}/$driverId/orders',
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
