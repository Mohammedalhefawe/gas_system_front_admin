import 'dart:io';
import 'package:gas_admin_app/core/extensions/multipart_file_extension.dart';
import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/ad_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class AdsRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<List<AdModel>>> getAds() async {
    AppResponse<List<AdModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.ads,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['ads'] as List<dynamic>?)
          ?.map((e) => AdModel.fromJson(e as Map<String, dynamic>))
          .toList();
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<AdModel>> addAd(AdModel ad, File? imageFile) async {
    AppResponse<AdModel> appResponse = AppResponse(success: false);

    try {
      final Map<String, dynamic> fields = ad.toJson()..remove('id_ad');
      fields['image'] = await imageFile?.toMultipartFile();
      final formData = dio.FormData.fromMap(fields);
      final response = await apiService.request(
        url: Api.ads,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
        params: formData,
        uploadImage: true,
      );
      appResponse.success = true;
      appResponse.data = AdModel.fromJson(response.data['data']);
      appResponse.successMessage =
          response.data['message'] ?? 'Ad added successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<AdModel>> updateAd(
    int idAd,
    AdModel ad,
    File? imageFile,
  ) async {
    AppResponse<AdModel> appResponse = AppResponse(success: false);

    try {
      final Map<String, dynamic> fields = ad.toJson()..remove('id_ad');
      fields['image'] = await imageFile?.toMultipartFile();
      final formData = dio.FormData.fromMap(fields);
      final response = await apiService.request(
        url: '${Api.ads}/$idAd',
        method: Method.put,
        requiredToken: true,
        withLogging: true,
        params: formData,
        uploadImage: true,
      );
      appResponse.success = true;
      appResponse.data = AdModel.fromJson(response.data['data']['ad']);
      appResponse.successMessage =
          response.data['message'] ?? 'Ad updated successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> deleteAd(int idAd) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.ads}/$idAd',
        method: Method.delete,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Ad deleted successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
