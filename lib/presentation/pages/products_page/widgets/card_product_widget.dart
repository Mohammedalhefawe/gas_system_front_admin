import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/models/product_model.dart';
import 'package:gas_admin_app/presentation/pages/products_page/products_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/products_page/add_edit_product_page.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';

class ProductTile extends GetView<ProductsPageController> {
  final ProductModel data;

  const ProductTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: AppSize.s100,
                    height: AppSize.s100,

                    child: data.imageUrl != null && data.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.s12),
                            child: Image.network(
                              data.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                            ),
                          )
                        : _buildImagePlaceholder(),
                  ),
                  if (!data.isAvailable)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p8,
                          vertical: AppPadding.p4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppSize.s8),
                            topRight: Radius.circular(AppSize.s8),
                          ),
                        ),
                        child: Text(
                          "OutOfStock".tr,
                          style: TextStyle(
                            color: ColorManager.colorWhite,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSize.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.productName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.colorFontPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: FontSize.s16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      semanticsLabel: data.productName,
                    ),
                    const SizedBox(height: AppSize.s8),
                    Text(
                      data.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorManager.colorDoveGray600,
                        fontSize: FontSize.s12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSize.s8),
                    Text(
                      '${data.price.toStringAsFixed(0)} ${'SP'.tr}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.colorPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: FontSize.s18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                onPressed: () {
                  Get.to(AddEditProductPage(product: data));
                },
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
                onPressed: () => controller.deleteProduct(data.productId),
                label: 'Delete'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Assets.icons.fuelIcon.svg(
        width: 60,
        colorFilter: const ColorFilter.mode(
          ColorManager.colorDoveGray600,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

Widget buildActionButton({
  required Widget icon,
  required Color backgroundColor,
  required VoidCallback onPressed,
  required String label,
}) {
  return Tooltip(
    message: label,
    child: Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: icon,
        onPressed: onPressed,
        splashRadius: 20,
      ),
    ),
  );
}
