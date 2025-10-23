import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/category_model.dart';
import 'package:gas_admin_app/data/repos/products_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';

class CategoriesPageController extends GetxController {
  final ProductsRepo productsRepo = Get.find<ProductsRepo>();
  final categories = <CategoryModel>[].obs;
  final loadingState = LoadingState.idle.obs;

  // Form controllers
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxBool isActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    loadingState.value = LoadingState.loading;
    final response = await productsRepo.getCategories();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    categories.value = response.data ?? [];
    loadingState.value = categories.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> addCategory() async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;
    final category = CategoryModel(
      categoryId: "0",
      categoryName: categoryNameController.text.trim(),
      description: descriptionController.text.trim(),
      isActive: isActive.value,
    );
    final response = await productsRepo.addCategory(category);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    categories.add(response.data!);
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'CategoryAdded'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> updateCategory(String categoryId) async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;
    final category = CategoryModel(
      categoryId: categoryId,
      categoryName: categoryNameController.text.trim(),
      description: descriptionController.text.trim(),
      isActive: isActive.value,
    );
    final response = await productsRepo.updateCategory(categoryId, category);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    final index = categories.indexWhere((c) => c.categoryId == categoryId);
    if (index >= 0) {
      categories[index] = response.data!;
    }
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'CategoryUpdated'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> deleteCategory(String categoryId) async {
    loadingState.value = LoadingState.loading;
    final response = await productsRepo.deleteCategory(categoryId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    categories.removeWhere((c) => c.categoryId == categoryId);
    loadingState.value = categories.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'CategoryDeleted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  bool _validateForm() {
    if (categoryNameController.text.trim().isEmpty) {
      CustomToasts(
        message: 'CategoryNameRequired'.tr,
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
    return true;
  }

  void clearForm() {
    categoryNameController.clear();
    descriptionController.clear();
    isActive.value = true;
  }

  @override
  void onClose() {
    categoryNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
