import 'dart:io';
import 'package:gas_admin_app/core/extensions/multipart_file_extension.dart';
import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/product_model.dart';
import 'package:gas_admin_app/data/models/category_model.dart';
import 'package:gas_admin_app/data/models/review_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class ProductsRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<List<ProductModel>>> getProducts() async {
    AppResponse<List<ProductModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.products,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<ProductModel>> addProduct(
    ProductModel product,
    File? imageFile,
  ) async {
    AppResponse<ProductModel> appResponse = AppResponse(success: false);

    try {
      final Map<String, dynamic> fields = product.toJson()
        ..remove('product_id');
      fields['image'] = await imageFile?.toMultipartFile();
      final formData = dio.FormData.fromMap(fields);
      final response = await apiService.request(
        url: Api.products,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
        params: formData,
        uploadImage: true,
      );
      appResponse.success = true;
      appResponse.data = ProductModel.fromJson(
        response.data['data']['product'],
      );
      appResponse.successMessage =
          response.data['message'] ?? 'Product added successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<ProductModel>> updateProduct(
    String productId,
    ProductModel product,
    File? imageFile,
  ) async {
    AppResponse<ProductModel> appResponse = AppResponse(success: false);

    try {
      final Map<String, dynamic> fields = product.toJson()
        ..remove('product_id');
      fields['image'] = await imageFile?.toMultipartFile();
      final formData = dio.FormData.fromMap(fields);
      final response = await apiService.request(
        url: '${Api.products}/$productId',
        method: Method.put,
        requiredToken: true,
        withLogging: true,
        params: formData,
        uploadImage: true,
      );
      appResponse.success = true;
      appResponse.data = ProductModel.fromJson(
        response.data['data']['product'],
      );
      appResponse.successMessage =
          response.data['message'] ?? 'Product updated successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> deleteProduct(String productId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.products}/$productId',
        method: Method.delete,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Product deleted successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<List<CategoryModel>>> getCategories() async {
    AppResponse<List<CategoryModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.categories,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data =
          (response.data?['data']?['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<CategoryModel>> addCategory(CategoryModel category) async {
    AppResponse<CategoryModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.categories,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
        params: category.toJson()..remove('category_id'),
      );
      appResponse.success = true;
      appResponse.data = CategoryModel.fromJson(
        response.data['data']['category'],
      );
      appResponse.successMessage =
          response.data['message'] ?? 'Category added successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<CategoryModel>> updateCategory(
    String categoryId,
    CategoryModel category,
  ) async {
    AppResponse<CategoryModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.categories}/$categoryId',
        method: Method.put,
        requiredToken: true,
        withLogging: true,
        params: category.toJson()..remove('category_id'),
      );
      appResponse.success = true;
      appResponse.data = CategoryModel.fromJson(
        response.data['data']['category'],
      );
      appResponse.successMessage =
          response.data['message'] ?? 'Category updated successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> deleteCategory(String categoryId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.categories}/$categoryId',
        method: Method.delete,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Category deleted successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<List<ReviewModel>>> getProductReviews(
    String productId,
  ) async {
    AppResponse<List<ReviewModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.products}/$productId/reviews',
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
