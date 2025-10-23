import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/ad_model.dart';
import 'package:gas_admin_app/data/repos/ads_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class AdsPageController extends GetxController {
  final AdsRepo adsRepo = Get.find<AdsRepo>();
  final ads = <AdModel>[].obs;
  final loadingState = LoadingState.idle.obs;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAds();
  }

  Future<void> fetchAds() async {
    loadingState.value = LoadingState.loading;
    final response = await adsRepo.getAds();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    ads.value = response.data ?? [];
    loadingState.value = ads.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> addAd() async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;
    final ad = AdModel(
      idAd: 0,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      link: linkController.text.trim(),
      image: null,
    );
    final response = await adsRepo.addAd(ad, selectedImage.value);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    ads.add(response.data!);
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'AdAdded'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> updateAd(int idAd) async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;
    final ad = AdModel(
      idAd: idAd,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      link: linkController.text.trim(),
      image: null,
    );
    final response = await adsRepo.updateAd(idAd, ad, selectedImage.value);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    final index = ads.indexWhere((a) => a.idAd == idAd);
    if (index >= 0) {
      ads[index] = response.data!;
    }
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'AdUpdated'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> deleteAd(int idAd) async {
    loadingState.value = LoadingState.loading;
    final response = await adsRepo.deleteAd(idAd);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    ads.removeWhere((a) => a.idAd == idAd);
    loadingState.value = ads.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'AdDeleted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      selectedImage.value = File(result.files.single.path!);
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      CustomToasts(
        message: 'TitleRequired'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      CustomToasts(
        message: 'DescriptionRequired'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    if (linkController.text.trim().isEmpty) {
      CustomToasts(
        message: 'LinkRequired'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    return true;
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    linkController.clear();
    selectedImage.value = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.onClose();
  }
}
