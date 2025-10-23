import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/models/product_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/custom_widgets/popup_menu_button_child.dart';
import 'package:gas_admin_app/presentation/pages/products_page/products_page_controller.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/utils.dart';
import 'package:get/get.dart';

class AddEditProductPage extends GetView<ProductsPageController> {
  final ProductModel? product;

  const AddEditProductPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      controller.productNameController.text = product!.productName;
      controller.descriptionController.text = product!.description;
      controller.priceController.text = product!.price.toString();
      controller.specialNotesController.text = product!.specialNotes ?? '';
      controller.isAvailable.value = product!.isAvailable;
      controller.selectedCategoryId.value = product!.categoryId.toString();
      controller.selectedImage.value = null;
    } else {
      controller.clearForm();
    }

    return Scaffold(
      appBar: NormalAppBar(
        title: product == null ? 'AddProduct'.tr : 'EditProduct'.tr,
        backIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              requiredField: true,
              title: 'ProductName'.tr,
              hint: 'EnterProductName'.tr,
              textEditingController: controller.productNameController,
              textInputType: TextInputType.text,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),

            if (product == null) ...[
              const SizedBox(height: AppSize.s12),
              Obx(() {
                return CustomTextField(
                  requiredField: true,
                  title: 'ProductImage'.tr,
                  hint: 'PickImage'.tr,
                  readOnly: true,
                  onTap: () {
                    controller.pickImage();
                  },
                  suffixIcon: controller.selectedImage.value != null
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(end: AppSize.s12),
                          child: InkWell(
                            child: Assets.icons.eyeOpenIcon.svg(),
                            onTap: () {
                              Utils.viewImage(
                                path: controller.selectedImage.value!.path,
                                isNetwork: false,
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                  textEditingController: controller.selectedImage.value != null
                      ? TextEditingController(
                          text: controller.selectedImage.value!.path
                              .split('/')
                              .last,
                        )
                      : TextEditingController(),
                  textInputType: TextInputType.text,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                );
              }),
            ],
            const SizedBox(height: AppSize.s12),

            CustomTextField(
              requiredField: true,
              title: 'Description'.tr,
              hint: 'EnterDescription'.tr,
              textEditingController: controller.descriptionController,
              textInputType: TextInputType.multiline,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              maxLines: 2,
              minLines: 2,
            ),
            const SizedBox(height: AppSize.s12),
            CustomTextField(
              requiredField: true,
              title: 'Price'.tr,
              hint: 'EnterPrice'.tr,
              textEditingController: controller.priceController,
              textInputType: TextInputType.number,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: AppSize.s12),
            CustomTextField(
              requiredField: false,
              title: 'SpecialNotes'.tr,
              hint: 'EnterSpecialNotes'.tr,
              textEditingController: controller.specialNotesController,
              textInputType: TextInputType.text,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: AppSize.s12),
            Obx(
              () => PopupMenuButton<String>(
                key: controller.categoryPopupMenuKey,
                color: ColorManager.colorGrey0,
                elevation: 2,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context) {
                  return controller.categories.map((category) {
                    return PopupMenuItem<String>(
                      value: category.categoryId.toString(),
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p12,
                        vertical: AppPadding.p8,
                      ),
                      child: PopUpMenuButtonChild(
                        text: category.categoryName,
                        color: ColorManager.colorFontPrimary,
                        icon: null,
                      ),
                      onTap: () {
                        controller.selectCategory(
                          category.categoryId.toString(),
                        );
                      },
                    );
                  }).toList();
                },
                child: CustomTextField(
                  title: 'Category'.tr,
                  hint:
                      controller.categories
                          .firstWhereOrNull(
                            (category) =>
                                category.categoryId.toString() ==
                                controller.selectedCategoryId.value,
                          )
                          ?.categoryName
                          .tr ??
                      'Category'.tr,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Transform.rotate(
                      angle: -math.pi / 2,
                      child: Assets.icons.arrowBackIcon.svg(width: AppSize.s22),
                    ),
                  ),
                  textEditingController: TextEditingController(
                    text:
                        controller.categories
                            .firstWhereOrNull(
                              (category) =>
                                  category.categoryId.toString() ==
                                  controller.selectedCategoryId.value,
                            )
                            ?.categoryName
                            .tr ??
                        '',
                  ),
                  textInputType: TextInputType.none,
                  readOnly: true,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      controller.selectedCategoryId.value == '0'
                      ? 'CategoryRequired'.tr
                      : null,
                  onTap: () {
                    controller.categoryPopupMenuKey.currentState
                        ?.showButtonMenu();
                  },
                  requiredField: true,
                ),
              ),
            ),
            const SizedBox(height: AppSize.s12),
            Row(
              children: [
                Text(
                  'IsAvailable'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    color: ColorManager.colorFontPrimary,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Switch(
                    value: controller.isAvailable.value,
                    onChanged: (value) => controller.isAvailable.value = value,
                    activeColor: ColorManager.colorPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSize.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  onPressed: () => Get.back(),
                  text: 'Cancel'.tr,
                  backgroundColor: ColorManager.colorWhite,
                  fontColor: ColorManager.colorDoveGray600,
                  border: Border.all(color: ColorManager.colorDoveGray600),
                ),
                const SizedBox(width: AppSize.s8),
                AppButton(
                  onPressed: () => product == null
                      ? controller.addProduct()
                      : controller.updateProduct(product!.productId),
                  text: product == null ? 'Add'.tr : 'Update'.tr,
                  backgroundColor: ColorManager.colorPrimary,
                  fontColor: ColorManager.colorWhite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
