import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/customers/customer_orders_page/customer_orders_controller.dart';
import 'package:gas_admin_app/presentation/pages/order_details_page/order_details_page.dart';
import 'package:gas_admin_app/presentation/util/date_converter.dart'
    show DateConverter;
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CustomerOrdersPage extends StatefulWidget {
  final int? customerId;

  const CustomerOrdersPage({super.key, this.customerId});

  @override
  State<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends State<CustomerOrdersPage>
    with SingleTickerProviderStateMixin {
  late CustomerOrdersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CustomerOrdersController(customerId: widget.customerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorGrey0,
        appBar: NormalAppBar(title: 'CustomerOrders'.tr, backIcon: true),
        body: _buildOrdersView(
          context,
          controller.myOrders,
          controller.myOrdersLoadingState,
          controller.loadingMoreOrdersState,
          controller.scrollController,
        ),
      ),
    );
  }

  Widget _buildOrdersView(
    BuildContext context,
    RxList<OrderModel> orders,
    Rx<LoadingState> loadingState,
    Rx<LoadingState> loadingMoreState,
    ScrollController scrollController,
  ) {
    return Obx(() {
      if (loadingState.value == LoadingState.loading) {
        return _buildShimmer();
      }
      if (loadingState.value == LoadingState.hasError) {
        return _buildErrorState(context);
      }
      if (orders.isEmpty) {
        return _buildEmptyState();
      }
      return RefreshIndicator(
        onRefresh: controller.refreshCustomerOrders,
        color: ColorManager.colorPrimary,
        backgroundColor: ColorManager.colorWhite,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppPadding.p12),
              sliver: SliverList.separated(
                itemCount: orders.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSize.s8),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _buildOrderCard(context, order);
                },
              ),
            ),
            if (loadingMoreState.value == LoadingState.loading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSize.s10),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: AppSize.s8)),
          ],
        ),
      );
    });
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return GestureDetector(
      onTap: () => Get.to(() => DriverOrderDetailsPage(), arguments: order),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p16,
                vertical: AppPadding.p8,
              ),
              title: Text(
                '#${order.orderId}',
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSize.s4),
                  Text(
                    DateConverter.formatDateOnly(order.orderDate),
                    style: TextStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.colorDoveGray600,
                    ),
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    '${"TotalPrice".tr} ${(double.parse(order.totalAmount) + double.parse(order.deliveryFee)).toStringAsFixed(0)} ${'SP'.tr}',
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      color: ColorManager.colorFontPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: buildStatusBadge(order.orderStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSize.s100,
              height: AppSize.s100,
              decoration: BoxDecoration(
                color: ColorManager.colorPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 50,
                color: ColorManager.colorPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Text(
              'NoCustomerOrders'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.s18,
                color: ColorManager.colorFontPrimary,
                fontWeight: FontWeight.w600,
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
            'FailedToLoadOrders'.tr,
            style: TextStyle(
              fontSize: FontSize.s18,
              color: ColorManager.colorDoveGray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSize.s12),
          GestureDetector(
            onTap: controller.refreshCustomerOrders,
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Shimmer.fromColors(
        baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
        highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
        child: CustomScrollView(
          slivers: [
            SliverList.separated(
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSize.s8),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSize.s12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p16,
                        vertical: AppPadding.p8,
                      ),
                      title: Container(
                        width: 100,
                        height: 16,
                        color: Colors.white,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSize.s8),
                          Container(
                            width: 150,
                            height: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(height: AppSize.s8),
                          Container(
                            width: 100,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 80,
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildStatusBadge(String status) {
  final Map<String, Map<String, dynamic>> statusMap = {
    'pending': {'color': ColorManager.colorPrimary, 'icon': Icons.access_time},
    'accepted': {'color': Colors.blue, 'icon': Icons.thumb_up_outlined},
    'rejected': {'color': Colors.red, 'icon': Icons.block},
    'on_the_way': {'color': Colors.orange, 'icon': Icons.delivery_dining},
    'completed': {'color': Colors.green, 'icon': Icons.check_circle_outline},
    'cancelled': {'color': Colors.red, 'icon': Icons.cancel_outlined},
  };

  final statusData =
      statusMap[status] ?? {'color': Colors.grey, 'icon': Icons.info_outline};

  final Color color = statusData['color'];
  final IconData icon = statusData['icon'];

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppPadding.p12,
      vertical: AppPadding.p8,
    ),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSize.s20),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSize.s14, color: color),
        const SizedBox(width: AppSize.s4),
        Text(
          status.tr,
          style: TextStyle(
            fontSize: FontSize.s12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}
