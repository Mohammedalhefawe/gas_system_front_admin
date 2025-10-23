import 'package:flutter/material.dart';
import 'package:gas_admin_app/data/models/ad_model.dart';
import 'package:gas_admin_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_admin_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_admin_app/presentation/pages/ads_page/ads_page_controller.dart';
import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/utils.dart';
import 'package:get/get.dart';

class AddEditAdPage extends GetView<AdsPageController> {
  final AdModel? ad;

  const AddEditAdPage({super.key, this.ad});

  @override
  Widget build(BuildContext context) {
    if (ad != null) {
      controller.titleController.text = ad!.title;
      controller.descriptionController.text = ad!.description;
      controller.linkController.text = ad!.link;
      controller.selectedImage.value = null;
    } else {
      controller.clearForm();
    }

    return Scaffold(
      appBar: NormalAppBar(
        title: ad == null ? 'AddAd'.tr : 'EditAd'.tr,
        backIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              requiredField: true,
              title: 'Title'.tr,
              hint: 'EnterTitle'.tr,
              textEditingController: controller.titleController,
              textInputType: TextInputType.text,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),
            if (ad == null) ...[
              const SizedBox(height: AppSize.s12),
              Obx(() {
                return CustomTextField(
                  requiredField: true,
                  title: 'AdImage'.tr,
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
              maxLines: 3,
              minLines: 3,
            ),
            const SizedBox(height: AppSize.s12),
            CustomTextField(
              requiredField: true,
              title: 'Link'.tr,
              hint: 'EnterLink'.tr,
              textEditingController: controller.linkController,
              textInputType: TextInputType.url,
              fillColor: ColorManager.colorWhite,
              borderRadius: AppSize.s8,
              autoValidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: AppSize.s12),
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
                  onPressed: () => ad == null
                      ? controller.addAd()
                      : controller.updateAd(ad!.idAd),
                  text: ad == null ? 'Add'.tr : 'Update'.tr,
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
