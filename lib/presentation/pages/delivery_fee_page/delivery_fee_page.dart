import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/delivery_fee_page/delivery_fee_controller.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class DeliveryFeePage extends GetView<DeliveryFeePageController> {
  const DeliveryFeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'ManageDeliveryFee'.tr, backIcon: true),
      body: Obx(() {
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
                  'FailedToLoad'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s12),
                GestureDetector(
                  onTap: controller.updateDeliveryFee,
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
        return Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'UpdateDeliveryFee'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.colorFontPrimary,
                  ),
                ),
                const SizedBox(height: AppSize.s16),
                CustomTextField(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p12,
                    ),
                    child: Text("SP".tr),
                  ),
                  requiredField: true,
                  title: 'DeliveryFee'.tr,
                  hint: 'EnterDeliveryFee'.tr,
                  textEditingController: controller.feeController,
                  textInputType: TextInputType.number,
                  fillColor: ColorManager.colorWhite,
                  borderRadius: AppSize.s8,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: AppSize.s24),
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
                      loadingMode:
                          controller.loadingState.value == LoadingState.loading,
                      onPressed: controller.updateDeliveryFee,
                      text: 'Update'.tr,
                      backgroundColor: ColorManager.colorPrimary,
                      fontColor: ColorManager.colorWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
