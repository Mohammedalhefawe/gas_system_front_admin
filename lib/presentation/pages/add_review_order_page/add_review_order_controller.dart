import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/models/app_response.dart';
import 'package:gas_admin_app/data/models/review_model.dart';
import 'package:gas_admin_app/data/repos/orders_repo.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';

class AddReviewOrderPageController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  final reviewController = TextEditingController();
  final rating = 0.obs;
  final loadingState = LoadingState.idle.obs;
  int? orderId;

  @override
  void onInit() {
    orderId = Get.arguments;
    super.onInit();
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> submitReview() async {
    if (loadingState.value == LoadingState.loading) return;

    if (rating.value < 1 || rating.value > 5) {
      CustomToasts(
        message: 'RatingRequired'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }

    final reviewText = reviewController.text.trim();
    if (reviewText.isEmpty) {
      CustomToasts(
        message: 'RequiredReview'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }
    loadingState.value = LoadingState.loading;

    final reviewModel = ReviewModel(
      productId: orderId!,
      rating: rating.value,
      review: reviewText.trim(),
    );

    final AppResponse<void> response = await orderRepo.submitOrderReview(
      orderId!,
      reviewModel,
    );

    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'ReviewSubmitted'.tr,
      type: CustomToastType.success,
    ).show();
    Get.back();
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
