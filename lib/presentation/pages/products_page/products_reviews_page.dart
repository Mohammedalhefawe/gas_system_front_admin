import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/products_page/products_page_controller.dart';
import 'package:gas_admin_app/presentation/util/date_converter.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductReviewsPage extends GetView<ProductsPageController> {
  final String productId;

  const ProductReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    controller.fetchProductReviews(productId);
    return Scaffold(
      appBar: NormalAppBar(title: 'ProductReviews'.tr, backIcon: true),
      body: Obx(() {
        if (controller.reviewsLoadingState.value == LoadingState.loading) {
          return _buildShimmerList();
        }
        if (controller.reviewsLoadingState.value == LoadingState.hasError) {
          return _buildErrorState(context);
        }
        if (controller.reviews.isEmpty) {
          return _buildEmptyState();
        }
        return _buildReviewsList(context);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_border,
              size: AppSize.s60,
              color: ColorManager.colorDoveGray600,
            ),
            const SizedBox(height: AppSize.s16),
            Text(
              'NoReviews'.tr,
              style: TextStyle(
                fontSize: FontSize.s18,
                color: ColorManager.colorDoveGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              'NoReviewsPrompt'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorDoveGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSize.s60,
            color: ColorManager.colorDoveGray600,
          ),
          const SizedBox(height: AppSize.s16),
          Text(
            'FailedToLoadReviews'.tr,
            style: TextStyle(
              fontSize: FontSize.s18,
              color: ColorManager.colorDoveGray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          GestureDetector(
            onTap: () => controller.fetchProductReviews(productId),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: ColorManager.colorDoveGray600),
                SizedBox(width: AppSize.s8),
                Text(
                  'TryAgain'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    color: ColorManager.colorDoveGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchProductReviews(productId),
      color: ColorManager.colorPrimary,
      backgroundColor: ColorManager.colorWhite,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        itemCount: controller.reviews.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSize.s8),
        itemBuilder: (context, index) {
          final review = controller.reviews[index];
          return Column(
            children: [
              if (index == 0) const SizedBox(height: AppSize.s8),
              CardWidget(
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.customer.fullName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: ColorManager.colorFontPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow[700],
                                size: AppSize.s18,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s8),
                      Text(
                        review.customer.user?.phoneNumber ?? "",
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.colorDoveGray600,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      const SizedBox(height: AppSize.s8),
                      Text(
                        DateConverter.formatDateOnly(review.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.colorDoveGray600,
                          fontSize: FontSize.s12,
                        ),
                      ),
                      if (review.review.isNotEmpty) ...[
                        const SizedBox(height: AppSize.s8),
                        Text(
                          review.review,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: ColorManager.colorFontPrimary,
                                fontSize: FontSize.s14,
                              ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Shimmer.fromColors(
        baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
        highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
        child: ListView.separated(
          itemCount: 3,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSize.s8),
          itemBuilder: (context, index) {
            return Column(
              children: [
                if (index == 0) const SizedBox(height: AppSize.s8),
                CardWidget(
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 16,
                              color: Colors.white,
                            ),
                            Container(
                              width: 80,
                              height: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSize.s8),
                        Container(width: 80, height: 12, color: Colors.white),
                        const SizedBox(height: AppSize.s8),
                        Container(width: 120, height: 12, color: Colors.white),
                        const SizedBox(height: AppSize.s8),
                        Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
