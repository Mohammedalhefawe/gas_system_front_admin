import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/products_page/products_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/products_page/widgets/card_product_widget.dart';
import 'package:gas_admin_app/presentation/pages/products_page/add_edit_product_page.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductsPage extends GetView<ProductsPageController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'ManageProducts'.tr, backIcon: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddEditProductPage());
        },
        backgroundColor: ColorManager.colorPrimary,
        child: Icon(Icons.add, color: ColorManager.colorWhite),
      ),
      body: Obx(() {
        if (controller.loadingState.value == LoadingState.loading) {
          return _buildShimmerGrid();
        }
        if (controller.loadingState.value == LoadingState.hasError) {
          return _buildErrorState();
        }
        if (controller.products.isEmpty) {
          return _buildEmptyState();
        }
        return _buildGridView(context);
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
              Icons.inventory_2_outlined,
              size: AppSize.s60,
              color: ColorManager.colorDoveGray600,
            ),
            const SizedBox(height: AppSize.s16),
            Text(
              'NoProducts'.tr,
              style: TextStyle(
                fontSize: FontSize.s18,
                color: ColorManager.colorDoveGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              'AddProductPrompt'.tr,
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

  Widget _buildErrorState() {
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
            'FailedToLoadProducts'.tr,
            style: TextStyle(
              fontSize: FontSize.s18,
              color: ColorManager.colorDoveGray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          GestureDetector(
            onTap: controller.fetchProducts,
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

  Widget _buildGridView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Column(
        children: [
          const SizedBox(height: AppSize.s8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchProducts,
              color: ColorManager.colorPrimary,
              child: ListView.separated(
                itemCount: controller.products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final product = controller.products[index];

                  return ProductTile(data: product);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSize.s8),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Shimmer.fromColors(
        baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
        highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
        child: ListView.separated(
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return Column(
              children: [
                if (index == 0) const SizedBox(height: AppSize.s8),
                CardWidget(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppSize.s100,
                            height: AppSize.s100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSize.s12),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSize.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: AppSize.s20),
                                Container(
                                  width: 80,
                                  height: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: AppSize.s8),
                                Container(
                                  width: 60,
                                  height: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
