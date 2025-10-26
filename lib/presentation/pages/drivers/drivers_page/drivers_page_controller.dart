import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/driver_model.dart';
import 'package:gas_admin_app/data/repos/driver_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class DriversPageController extends GetxController {
  final DriversRepo driversRepo = Get.find<DriversRepo>();
  final drivers = <DriverModel>[].obs;
  final loadingState = LoadingState.idle.obs;

  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController maxCapacityController = TextEditingController();
  final RxString countryCode = '+963'.obs;
  final RxString formattedMobileNumber = ''.obs;
  final RxBool isPassword = false.obs;
  final RxBool isConfirmPassword = false.obs;
  final formKey = GlobalKey<FormState>();

  String get fullNumber =>
      "${countryCode.value}${sanitizePhoneNumber(formattedMobileNumber.value)}";

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    loadingState.value = LoadingState.loading;
    final response = await driversRepo.getDrivers();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    drivers.value = response.data ?? [];
    loadingState.value = drivers.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> addDriver() async {
    if (!formKey.currentState!.validate()) return;

    if (!GetUtils.isPhoneNumber(fullNumber)) {
      CustomToasts(
        message: 'RequiredPhoneNumber'.tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }

    if (loadingState.value == LoadingState.loading) return;
    loadingState.value = LoadingState.loading;

    final driverData = {
      'full_name': fullNameController.text.trim(),
      'phone_number': fullNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
      'password': passwordController.text.trim(),
      'password_confirmation': passwordConfirmationController.text.trim(),
      'vehicle_type': vehicleTypeController.text.trim(),
      'license_number': licenseNumberController.text.trim(),
      'max_capacity': maxCapacityController.text.trim(),
    };

    final response = await driversRepo.addDriver(driverData);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      if (response.getErrorMessage() == "Validation failed") {
        CustomToasts(
          message:
              "${response.getErrorMessage()} , check Mobile Number and License Number",
          type: CustomToastType.error,
        ).show();
        return;
      }
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    fetchDrivers();
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'DriverAdded'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> toggleBlockDriver(int driverId, bool isBlocked) async {
    loadingState.value = LoadingState.loading;
    final response = await driversRepo.toggleBlockDriver(driverId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    final index = drivers.indexWhere((d) => d.driverId == driverId);
    if (index >= 0) {
      drivers[index] = drivers[index].copyWith(
        blocked: !drivers[index].blocked,
      );
    }
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message:
          response.successMessage ??
          (isBlocked ? 'DriverUnblocked'.tr : 'DriverBlocked'.tr),
      type: CustomToastType.success,
    ).show();
  }

  void selectPhoneNumber(String number) {
    formattedMobileNumber.value = number;
  }

  String sanitizePhoneNumber(String number) {
    if (countryCode.value == '+963' && number.startsWith('0')) {
      return number.substring(1);
    }
    return number;
  }

  void clearForm() {
    fullNameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    vehicleTypeController.clear();
    licenseNumberController.clear();
    maxCapacityController.clear();
    formattedMobileNumber.value = '';
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    vehicleTypeController.dispose();
    licenseNumberController.dispose();
    maxCapacityController.dispose();
    super.onClose();
  }
}
