import 'package:gas_admin_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  List<ManageHomeModel> homeManagementList = [
    ManageHomeModel(
      name: "ManageProducts".tr,
      icon: Assets.icons.fuelIcon,
      onTap: () {
        Get.toNamed(AppRoutes.productsRoute);
      },
    ),
    ManageHomeModel(
      name: "ManageAds".tr,
      icon: Assets.icons.adsIcon,
      onTap: () {
        Get.toNamed(AppRoutes.adsRoute);
      },
    ),
    ManageHomeModel(
      name: "ManageCategories".tr,
      icon: Assets.icons.shopIcon,
      onTap: () {
        Get.toNamed(AppRoutes.categoriesRoute);
      },
    ),
    ManageHomeModel(
      name: "ManageDrivers".tr,
      icon: Assets.icons.motorIcon,
      onTap: () {
        Get.toNamed(AppRoutes.driversRoute);
      },
    ),
    ManageHomeModel(
      name: "ManageUsers".tr,
      icon: Assets.icons.userIcon,
      onTap: () {},
    ),
  ];
}

class ManageHomeModel {
  final String name;
  final SvgGenImage icon;
  final void Function()? onTap;
  ManageHomeModel({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}
