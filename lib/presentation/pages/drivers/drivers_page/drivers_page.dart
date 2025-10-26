import 'package:flutter/material.dart';
import 'package:gas_admin_app/core/extensions/phone_call_extension.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/driver_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/drivers/drivers_page/add_driver_page.dart';
import 'package:gas_admin_app/presentation/pages/drivers/driver_orders_page/driver_orders_page.dart';
import 'package:gas_admin_app/presentation/pages/products_page/widgets/card_product_widget.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'drivers_page_controller.dart';

class DriversPage extends GetView<DriversPageController> {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'ManageDrivers'.tr, backIcon: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddDriverPage()),
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
        if (controller.drivers.isEmpty) {
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
              Icons.person_off_outlined,
              size: AppSize.s60,
              color: ColorManager.colorDoveGray600,
            ),
            const SizedBox(height: AppSize.s16),
            Text(
              'NoDrivers'.tr,
              style: TextStyle(
                fontSize: FontSize.s18,
                color: ColorManager.colorDoveGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              'AddDriverPrompt'.tr,
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
            'FailedToLoadDrivers'.tr,
            style: TextStyle(
              fontSize: FontSize.s18,
              color: ColorManager.colorDoveGray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          GestureDetector(
            onTap: controller.fetchDrivers,
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
              onRefresh: controller.fetchDrivers,
              color: ColorManager.colorPrimary,
              backgroundColor: ColorManager.colorWhite,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSize.s8,
                  mainAxisSpacing: AppSize.s8,
                  childAspectRatio: 0.9,
                ),
                itemCount: controller.drivers.length,
                // separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final driver = controller.drivers[index];
                  return DriverTile(data: driver);
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p8,
      ),
      child: Shimmer.fromColors(
        baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
        highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSize.s8,
            mainAxisSpacing: AppSize.s8,
            childAspectRatio: 0.9,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return CardWidget(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: AppSize.s100,
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
            );
          },
        ),
      ),
    );
  }
}

class DriverTile extends GetView<DriversPageController> {
  final DriverModel data;

  const DriverTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.fullName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorManager.colorFontPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.s8),

          Text(
            data.user.phoneNumber,
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.colorDoveGray600,
              fontSize: FontSize.s12,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            '${'VehicleType'.tr}: ${data.vehicleType}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.colorDoveGray600,
              fontSize: FontSize.s12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            '${'VehicleNumber'.tr}: ${data.licenseNumber}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.colorDoveGray600,
              fontSize: FontSize.s12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.s8),
          Row(
            children: [
              Icon(
                data.blocked ? Icons.block : Icons.check_circle_outline,
                size: AppSize.s14,
                color: data.blocked ? Colors.red : Colors.green,
              ),
              const SizedBox(width: AppSize.s4),
              Text(
                data.blocked ? 'Blocked'.tr : 'Active'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: data.blocked ? Colors.red : Colors.green,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildActionButton(
                icon: Assets.icons.blockIcon.svg(
                  width: 18,
                  colorFilter: ColorFilter.mode(
                    data.blocked ? Colors.green : Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: (data.blocked ? Colors.green : Colors.red)
                    .withValues(alpha: 0.1),
                onPressed: () =>
                    controller.toggleBlockDriver(data.driverId, data.blocked),
                label: data.blocked ? 'Unblock'.tr : 'Block'.tr,
              ),
              const SizedBox(width: AppSize.s8),
              buildActionButton(
                icon: Assets.icons.fuelIcon.svg(
                  width: 18,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: ColorManager.colorPrimary.withValues(
                  alpha: 0.1,
                ),
                onPressed: () =>
                    Get.to(() => DriverOrdersPage(driverId: data.driverId)),
                label: 'ViewOrders'.tr,
              ),
              const SizedBox(width: AppSize.s8),
              buildActionButton(
                icon: Assets.icons.callIcon.svg(
                  width: 18,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorDoveGray600,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: ColorManager.colorDoveGray600.withValues(
                  alpha: 0.1,
                ),
                onPressed: () {
                  data.user.phoneNumber.makePhoneCall();
                },

                label: 'Call'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
