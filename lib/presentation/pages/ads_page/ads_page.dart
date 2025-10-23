import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/ad_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/ads_page/add_edit_ad_page.dart';
import 'package:gas_admin_app/presentation/pages/ads_page/ads_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/products_page/widgets/card_product_widget.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AdsPage extends GetView<AdsPageController> {
  const AdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'ManageAds'.tr, backIcon: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddEditAdPage()),
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
        if (controller.ads.isEmpty) {
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
              Icons.campaign_outlined,
              size: AppSize.s60,
              color: ColorManager.colorDoveGray600,
            ),
            const SizedBox(height: AppSize.s16),
            Text(
              'NoAds'.tr,
              style: TextStyle(
                fontSize: FontSize.s18,
                color: ColorManager.colorDoveGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              'AddAdPrompt'.tr,
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
            'FailedToLoadAds'.tr,
            style: TextStyle(
              fontSize: FontSize.s18,
              color: ColorManager.colorDoveGray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          GestureDetector(
            onTap: controller.fetchAds,
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
              onRefresh: controller.fetchAds,
              color: ColorManager.colorPrimary,
              backgroundColor: ColorManager.colorWhite,
              child: ListView.separated(
                itemCount: controller.ads.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final ad = controller.ads[index];
                  return AdTile(data: ad);
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
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              children: [
                if (index == 0) SizedBox(height: AppSize.s8),
                CardWidget(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSize.s12),
                      Container(width: 100, height: 16, color: Colors.white),
                      const SizedBox(height: AppSize.s8),
                      Container(width: 80, height: 12, color: Colors.white),
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

class AdTile extends GetView<AdsPageController> {
  final AdModel data;

  const AdTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  data.image!,

                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: AppSize.s100,
                    color: ColorManager.colorGrey2,
                    child: Icon(
                      Icons.image_not_supported,
                      color: ColorManager.colorDoveGray600,
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              height: AppSize.s100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s12),
                color: ColorManager.colorGrey2,
              ),
              child: Icon(Icons.image, color: ColorManager.colorDoveGray600),
            ),
          const SizedBox(height: AppSize.s12),
          Text(
            data.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorManager.colorFontPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSize.s8),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.colorDoveGray600,
              fontSize: FontSize.s12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            data.link,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.colorPrimary,
              fontSize: FontSize.s12,
              decoration: TextDecoration.underline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSize.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildActionButton(
                icon: Assets.icons.editIcon.svg(
                  width: 18,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: ColorManager.colorPrimary.withValues(
                  alpha: 0.1,
                ),
                onPressed: () => Get.to(() => AddEditAdPage(ad: data)),
                label: 'Edit'.tr,
              ),
              const SizedBox(width: AppSize.s8),
              buildActionButton(
                icon: Assets.icons.deleteIcon.svg(
                  width: 18,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorError,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: ColorManager.colorError.withValues(alpha: 0.1),
                onPressed: () => controller.deleteAd(data.idAd),
                label: 'Delete'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
