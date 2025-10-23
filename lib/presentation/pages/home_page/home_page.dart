import 'package:flutter/material.dart';
import 'package:gas_admin_app/presentation/pages/home_page/home_page_controller.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';
import 'package:gas_admin_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSize.s12,
        mainAxisSpacing: AppSize.s12,
        childAspectRatio: 1.5,
      ),
      itemCount: controller.homeManagementList.length,
      itemBuilder: (context, index) {
        final item = controller.homeManagementList[index];
        return InkWell(
          onTap: item.onTap,
          child: CardWidget(
            color: ColorManager.colorPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                item.icon.svg(
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorWhite,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: AppSize.s12),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: ColorManager.colorWhite,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
