import 'dart:convert';
import 'package:gas_admin_app/core/services/network_service/api.dart';
import 'package:gas_admin_app/data/dto/login_response_dto.dart';
import 'package:gas_admin_app/data/dto/register_response_dto.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/user_model.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/core/services/cache_service.dart';
import 'package:gas_admin_app/core/services/network_service/error_handler.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/data/dto/register_dto.dart';

class UsersRepo extends GetxService {
  ApiService apiService = Get.find<ApiService>();
  CacheService cacheService = Get.find<CacheService>();

  var userLoggedIn = false.obs;
  var loggedInUser = Rx<UserModel>(UserModel.emptyUser());

  Future clearApp() async {
    await cacheService.clearCache();
    Get.offAllNamed(AppRoutes.loginRoute);
  }

  void checkUserLoggedInState() {
    userLoggedIn.value = cacheService.isLoggedIn();
    if (userLoggedIn.value) {
      loggedInUser.value = cacheService.getLoggedInUser();
    } else {
      loggedInUser.value = UserModel.emptyUser();
    }
  }

  Future<bool> checkLoggedInAndShowDialog() async {
    bool isLoggedIn = userLoggedIn.value;
    if (!isLoggedIn) {
      await Get.toNamed(AppRoutes.loginRoute);
    }
    isLoggedIn = userLoggedIn.value;
    return isLoggedIn;
  }

  // void refreshUserObject(UserModel userModel) {
  //   cacheService.updateUserInfo(userModel);
  //   loggedInUser.value = userModel.copyWith();
  //   loggedInUser.refresh();
  // }

  // void refreshUserImage(String imageName) {
  //   final updatedUser = loggedInUser.value.copyWith(image: imageName);
  //   cacheService.updateUserInfo(updatedUser);
  //   loggedInUser.value = updatedUser;
  //   loggedInUser.refresh();
  // }

  bool isMe(UserModel userModel) {
    return userModel == loggedInUser.value;
  }

  UserModel getLoggedInUser() => cacheService.getLoggedInUser();

  Future<AppResponse<LoginResponseDto>> login({
    required String phoneNumber,
    required String password,
  }) async {
    AppResponse<LoginResponseDto> appResponse = AppResponse(success: false);

    var data = jsonEncode({"phone_number": phoneNumber, "password": password});

    try {
      final response = await apiService.request(
        url: Api.login,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = LoginResponseDto.fromJson(response.data);
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> logout() async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.logout,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    if (appResponse.success) {
      cacheService.clearCache();
      userLoggedIn.value = false;
      loggedInUser.value = UserModel.emptyUser();
    }
    return appResponse;
  }

  Future<AppResponse<RegisterResponseDto>> register({
    required RegisterDto registerDto,
  }) async {
    AppResponse<RegisterResponseDto> appResponse = AppResponse(success: false);
    try {
      final data = jsonEncode(registerDto.toJson());
      final response = await apiService.request(
        url: Api.register,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = RegisterResponseDto.fromJson(response.data['data']);
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> verifyOTP({
    required String phoneNumber,
    required String pin,
  }) async {
    AppResponse appResponse = AppResponse(success: false);

    try {
      final data = jsonEncode({"phone_number": phoneNumber, "pin": pin});
      final response = await apiService.request(
        url: Api.verify,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> resendPin({required String phoneNumber}) async {
    AppResponse appResponse = AppResponse(success: false);

    try {
      final data = jsonEncode({"phone_number": phoneNumber});
      final response = await apiService.request(
        url: Api.resendPin,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> forgetPassword({required String phoneNumber}) async {
    AppResponse appResponse = AppResponse(success: false);

    try {
      final data = jsonEncode({"phone_number": phoneNumber});
      final response = await apiService.request(
        url: Api.forgetPassword,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
      appResponse.data = response.data['data'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> verifyResetPin({
    required String phoneNumber,
    required String pin,
  }) async {
    AppResponse appResponse = AppResponse(success: false);
    try {
      final data = jsonEncode({"phone_number": phoneNumber, "pin": pin});
      final response = await apiService.request(
        url: Api.verifyResetPin,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> resetPassword({
    required String phoneNumber,
    required String pin,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    AppResponse appResponse = AppResponse(success: false);

    try {
      final data = jsonEncode({
        "phone_number": phoneNumber,
        "pin": pin,
        "new_password": newPassword,
        "new_password_confirmation": newPasswordConfirmation,
      });
      final response = await apiService.request(
        url: Api.resetPassword,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
