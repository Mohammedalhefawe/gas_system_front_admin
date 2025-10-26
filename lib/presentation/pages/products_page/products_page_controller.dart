import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/product_model.dart';
import 'package:gas_admin_app/data/models/category_model.dart';
import 'package:gas_admin_app/data/models/review_model.dart';
import 'package:gas_admin_app/data/repos/products_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class ProductsPageController extends GetxController {
  final ProductsRepo productsRepo = Get.find<ProductsRepo>();
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final reviews = <ReviewModel>[].obs;
  final loadingState = LoadingState.idle.obs;
  final reviewsLoadingState = LoadingState.idle.obs;

  // Form controllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specialNotesController = TextEditingController();
  final RxBool isAvailable = true.obs;
  final RxString selectedCategoryId = '0'.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final GlobalKey<PopupMenuButtonState> categoryPopupMenuKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts() async {
    loadingState.value = LoadingState.loading;
    final response = await productsRepo.getProducts();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    products.value = response.data ?? [];
    loadingState.value = products.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> fetchCategories() async {
    final response = await productsRepo.getCategories();
    if (!response.success) {
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    categories.value = response.data ?? [];
  }

  Future<void> addProduct() async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;

    final product = ProductModel(
      productId: 0,
      categoryId: selectedCategoryId.value,
      productName: productNameController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      isAvailable: isAvailable.value,
      specialNotes: specialNotesController.text.trim().isEmpty
          ? null
          : specialNotesController.text.trim(),
      imageUrl: '',
      createdAt: '',
    );

    final response = await productsRepo.addProduct(
      product,
      selectedImage.value,
    );
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    fetchProducts();
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'ProductAdded'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> updateProduct(String productId) async {
    if (!_validateForm()) return;
    loadingState.value = LoadingState.loading;

    final product = ProductModel(
      productId: int.parse(productId),
      categoryId: selectedCategoryId.value,
      productName: productNameController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      isAvailable: isAvailable.value,
      specialNotes: specialNotesController.text.trim().isEmpty
          ? null
          : specialNotesController.text.trim(),
      imageUrl: '',
      createdAt: '',
    );

    final response = await productsRepo.updateProduct(
      productId,
      product,
      selectedImage.value,
    );
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    final index = products.indexWhere((p) => p.productId == productId);
    if (index >= 0) {
      products[index] = response.data!;
    }
    loadingState.value = LoadingState.doneWithData;
    clearForm();
    Get.back();
    CustomToasts(
      message: response.successMessage ?? 'ProductUpdated'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> deleteProduct(String productId) async {
    loadingState.value = LoadingState.loading;
    final response = await productsRepo.deleteProduct(productId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    products.removeWhere((p) => p.productId == productId);
    loadingState.value = products.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'ProductDeleted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> fetchProductReviews(String productId) async {
    reviewsLoadingState.value = LoadingState.loading;
    final response = await productsRepo.getProductReviews(productId);
    if (!response.success) {
      reviewsLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    reviews.value = response.data ?? [];
    reviewsLoadingState.value = reviews.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
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

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
  }

  bool _validateForm() {
    if (productNameController.text.trim().isEmpty) {
      CustomToasts(
        message: 'ProductNameRequired'.tr,
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
    if (priceController.text.trim().isEmpty ||
        double.tryParse(priceController.text.trim()) == null) {
      CustomToasts(
        message: 'ValidPriceRequired'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    if (selectedCategoryId.value == '0') {
      CustomToasts(
        message: 'CategoryRequired'.tr,
        type: CustomToastType.warning,
      ).show();
      return false;
    }
    return true;
  }

  void clearForm() {
    productNameController.clear();
    descriptionController.clear();
    priceController.clear();
    specialNotesController.clear();
    isAvailable.value = true;
    selectedCategoryId.value = '0';
    selectedImage.value = null;
  }

  @override
  void onClose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    specialNotesController.dispose();
    super.onClose();
  }
}
