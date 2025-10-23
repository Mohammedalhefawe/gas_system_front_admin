import 'package:flutter/material.dart';
import 'package:gas_admin_app/core/extensions/phone_call_extension.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/order_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/order_details_page/order_details_controller.dart';
import 'package:gas_admin_app/presentation/pages/orders_page/orders_page.dart';
import 'package:gas_admin_app/presentation/util/date_converter.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DriverOrderDetailsPage extends GetView<OrderDetailsController> {
  const DriverOrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderDetailsController());
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorGrey0,
        appBar: NormalAppBar(title: 'OrderDetails'.tr, backIcon: true),
        body: Obx(() {
          if (controller.loadingState.value == LoadingState.loading) {
            return _buildShimmerDetails();
          }
          if (controller.loadingState.value == LoadingState.doneWithNoData) {
            return _buildErrorState();
          }
          return _buildOrderDetails(context);
        }),
      ),
    );
  }

  Widget _buildErrorState() {
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
                Icons.error_outline,
                size: 50,
                color: ColorManager.colorPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Text(
              'OrderNotFound'.tr,
              style: TextStyle(
                fontSize: FontSize.s22,
                fontWeight: FontWeight.w700,
                color: ColorManager.colorFontPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s12),
            Text(
              'OrderNotFoundPrompt'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.s16,
                color: ColorManager.colorDoveGray600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    final order = controller.order.value!;
    final totalAmount =
        (double.parse(order.totalAmount) + double.parse(order.deliveryFee))
            .toStringAsFixed(0);

    return SingleChildScrollView(
      // physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: AppSize.s8),
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppPadding.p20),
            decoration: BoxDecoration(color: ColorManager.colorWhite),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.orderId}',
                                style: TextStyle(
                                  fontSize: FontSize.s20,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.colorFontPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSize.s4),
                              Text(
                                DateConverter.formatDateOnly(order.orderDate),
                                style: TextStyle(
                                  fontSize: FontSize.s14,
                                  color: ColorManager.colorDoveGray600,
                                ),
                              ),
                              const SizedBox(height: AppSize.s4),
                              Text(
                                '${order.orderStatus}Des'.tr,
                                style: TextStyle(
                                  fontSize: FontSize.s14,
                                  color: ColorManager.colorDoveGray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        buildStatusBadge(order.orderStatus),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSize.s8),

          // Order Information Card
          _buildInfoCard(
            title: 'OrderInformation'.tr,
            children: [
              _buildInfoRow(
                Assets.icons.userIcon,
                'FullName'.tr,
                order.customer?.fullName ?? "Unknown",
              ),
              InkWell(
                onTap: () {
                  order.customer?.user?.phoneNumber.makePhoneCall();
                },
                child: _buildInfoRow(
                  Assets.icons.callIcon,
                  'numberPhone'.tr,
                  order.customer?.user?.phoneNumber ?? "Unknown",
                ),
              ),
              _buildInfoRow(
                Assets.icons.motorIcon,
                'DeliveryType'.tr,
                order.immediate
                    ? 'ImmediateDelivery'.tr
                    : 'ScheduledDelivery'.tr,
              ),
              if (order.deliveryDate != null)
                _buildInfoRow(
                  Assets.icons.dateIcon,
                  'DeliveryDate'.tr,
                  DateConverter.formatDateOnly(order.deliveryDate!),
                ),
              if (order.deliveryTime != null)
                _buildInfoRow(
                  Assets.icons.timeIcon,
                  'DeliveryTime'.tr,
                  DateConverter.formatTimeOnly(order.deliveryTime!),
                ),

              _buildInfoRow(
                Assets.icons.paymentIcon,
                'Payment Method'.tr,
                order.paymentMethod.tr,
              ),
              _buildInfoRow(
                Assets.icons.paymentIcon,
                'Payment Status'.tr,
                order.paymentStatus.tr,
              ),
              if (order.note != null)
                _buildInfoRow(Assets.icons.detailsIcon, 'Note'.tr, order.note!),
            ],
          ),

          const SizedBox(height: AppSize.s8),

          // Order Items Card
          _buildInfoCard(
            title: 'OrderItems'.tr,
            children: [...order.items.map((item) => _buildOrderItemCard(item))],
          ),

          const SizedBox(height: AppSize.s8),
          _buildInfoCard(
            title: 'DeliveryInformation'.tr,
            children: [
              _buildInfoRow(
                Assets.icons.locationPin,
                'City'.tr,
                order.address.city,
              ),
              _buildInfoRow(
                Assets.icons.locationPin,
                'Address'.tr,
                order.address.address,
              ),

              if (order.address.floorNumber != null)
                _buildInfoRow(
                  Assets.icons.buildingIcon,
                  'FloorNumber'.tr,
                  order.address.floorNumber!,
                ),

              if (order.address.details != null)
                _buildInfoRow(
                  Assets.icons.detailsIcon,
                  'Details'.tr,
                  order.address.details!,
                ),
            ],
          ),

          const SizedBox(height: AppSize.s8),

          // Summary Card
          _buildInfoCard(
            title: 'OrderSummary'.tr,
            children: [
              _buildSummaryRow(
                'Subtotal',
                '${double.parse(order.totalAmount).toStringAsFixed(0)} ${'SP'.tr}',
              ),
              const SizedBox(height: AppSize.s8),
              _buildSummaryRow(
                'DeliveryFee',
                '${double.parse(order.deliveryFee).toStringAsFixed(0)} ${'SP'.tr}',
              ),
              const SizedBox(height: AppSize.s12),
              Container(
                height: 1,
                color: ColorManager.colorGrey2.withValues(alpha: 0.15),
              ),
              const SizedBox(height: AppSize.s12),
              _buildSummaryRow(
                'Total',
                '$totalAmount ${'SP'.tr}',
                isTotal: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: BoxDecoration(color: ColorManager.colorWhite),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.colorFontPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    SvgGenImage icon,
    String label,
    String value, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon.svg(
            height: AppSize.s22,
            width: AppSize.s22,
            colorFilter: ColorFilter.mode(
              ColorManager.colorDoveGray600,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSize.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: FontSize.s13,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s4),
                Text(
                  value,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.colorFontPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr,
          style: TextStyle(
            fontSize: isTotal ? FontSize.s16 : FontSize.s14,
            color: isTotal
                ? ColorManager.colorFontPrimary
                : ColorManager.colorDoveGray600,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? FontSize.s18 : FontSize.s14,
            color: isTotal
                ? ColorManager.colorPrimary
                : ColorManager.colorFontPrimary,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.s12),
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.colorGrey0,
        borderRadius: BorderRadius.circular(AppSize.s12),
        border: Border.all(
          color: ColorManager.colorGrey2.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.product.productName,
                  style: TextStyle(
                    fontSize: FontSize.s15,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.colorFontPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${double.parse(item.subtotal).toStringAsFixed(0)} ${'SP'.tr}',
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.colorPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'Quantity'.tr}: ${item.quantity}',
                style: TextStyle(
                  fontSize: FontSize.s13,
                  color: ColorManager.colorDoveGray600,
                ),
              ),
              Text(
                '${'each'.tr} ${double.parse(item.unitPrice).toStringAsFixed(0)} ${'SP'.tr}',
                style: TextStyle(
                  fontSize: FontSize.s13,
                  color: ColorManager.colorDoveGray600,
                ),
              ),
            ],
          ),
          if (item.productNotes != null) ...[
            const SizedBox(height: AppSize.s8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: BoxDecoration(
                color: ColorManager.colorWhite,
                borderRadius: BorderRadius.circular(AppSize.s8),
              ),
              child: Text(
                '${'Notes'.tr}: ${item.productNotes}',
                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.colorDoveGray600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerDetails() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            // Header Shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s20),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Info Card Shimmer
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Items Card Shimmer
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
            const SizedBox(height: AppSize.s16),
            // Summary Card Shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.s16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
