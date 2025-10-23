import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/models/category_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/categories_page/categories_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/products_page/widgets/card_product_widget.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesPage extends GetView<CategoriesPageController> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'ManageCategories'.tr, backIcon: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditCategoryDialog(context),
        backgroundColor: ColorManager.colorPrimary,
        child: Icon(Icons.add, color: ColorManager.colorWhite),
      ),
      body: Obx(() {
        if (controller.loadingState.value == LoadingState.loading) {
          return Column(
            children: [
              const SizedBox(height: AppSize.s8),
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  itemBuilder: (context, index) => _buildShimmerCategoryItem(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSize.s8),
                ),
              ),
            ],
          );
        }
        if (controller.loadingState.value == LoadingState.hasError) {
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
                  'FailedToLoadCategories'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s12),
                GestureDetector(
                  onTap: controller.fetchCategories,
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
        if (controller.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: AppSize.s60,
                  color: ColorManager.colorDoveGray600,
                ),
                const SizedBox(height: AppSize.s16),
                Text(
                  'NoCategories'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s8),
                Text(
                  'AddCategoryPrompt'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.colorDoveGray600,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            const SizedBox(height: AppSize.s8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchCategories,
                color: ColorManager.colorPrimary,
                backgroundColor: ColorManager.colorWhite,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return _buildCategoryItem(context, category);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSize.s8),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryModel category) {
    return CardWidget(
      color: ColorManager.colorWhite,
      padding: const EdgeInsets.all(AppPadding.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s26,
                height: AppSize.s26,
                decoration: BoxDecoration(
                  color: ColorManager.colorPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSize.s8),
                ),
                child: Icon(
                  Icons.category_outlined,
                  size: AppSize.s18,
                  color: ColorManager.colorPrimary,
                ),
              ),
              const SizedBox(width: AppSize.s12),
              Expanded(
                child: Text(
                  category.categoryName,
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.colorFontPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.description,
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.colorDoveGray600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSize.s4),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: AppSize.s16,
                    color: category.isActive
                        ? ColorManager.colorPrimary
                        : ColorManager.colorDoveGray600,
                  ),
                  const SizedBox(width: AppSize.s6),
                  Text(
                    category.isActive ? 'Active'.tr : 'Inactive'.tr,
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      color: category.isActive
                          ? ColorManager.colorPrimary
                          : ColorManager.colorDoveGray600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          Container(
            height: 1,
            color: ColorManager.colorGrey2.withValues(alpha: 0.08),
          ),
          const SizedBox(height: AppSize.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: SizedBox()),
              Row(
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
                      alpha: 0.08,
                    ),
                    onPressed: () =>
                        _showAddEditCategoryDialog(context, category: category),
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
                    backgroundColor: ColorManager.colorError.withValues(
                      alpha: 0.08,
                    ),
                    onPressed: () =>
                        controller.deleteCategory(category.categoryId),
                    label: 'Delete'.tr,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCategoryItem() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: CardWidget(
        color: ColorManager.colorWhite,
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSize.s26,
                  height: AppSize.s26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Container(width: 120, height: 18, color: Colors.white),
              ],
            ),
            const SizedBox(height: AppSize.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSize.s4),
                Row(
                  children: [
                    Container(
                      width: AppSize.s16,
                      height: AppSize.s16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: AppSize.s6),
                    Container(width: 100, height: 14, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSize.s16),
            Container(height: 1, color: Colors.white),
            const SizedBox(height: AppSize.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SizedBox()),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSize.s8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditCategoryDialog(
    BuildContext context, {
    CategoryModel? category,
  }) {
    if (category != null) {
      controller.categoryNameController.text = category.categoryName;
      controller.descriptionController.text = category.description;
      controller.isActive.value = category.isActive;
    } else {
      controller.clearForm();
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category == null ? 'AddCategory'.tr : 'EditCategory'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.colorFontPrimary,
                  ),
                ),
                const SizedBox(height: AppSize.s16),
                CustomTextField(
                  requiredField: true,
                  title: 'CategoryName'.tr,
                  hint: 'EnterCategoryName'.tr,
                  textEditingController: controller.categoryNameController,
                  textInputType: TextInputType.text,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: AppSize.s16),
                CustomTextField(
                  requiredField: true,
                  title: 'Description'.tr,
                  hint: 'EnterDescription'.tr,
                  textEditingController: controller.descriptionController,
                  textInputType: TextInputType.multiline,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 3,
                  minLines: 3,
                ),
                const SizedBox(height: AppSize.s16),
                Row(
                  children: [
                    Text(
                      'IsActive'.tr,
                      style: TextStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.colorFontPrimary,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Switch(
                        value: controller.isActive.value,
                        onChanged: (value) => controller.isActive.value = value,
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
                      onPressed: () => category == null
                          ? controller.addCategory()
                          : controller.updateCategory(category.categoryId),
                      text: category == null ? 'Add'.tr : 'Update'.tr,
                      backgroundColor: ColorManager.colorPrimary,
                      fontColor: ColorManager.colorWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
