import 'package:gas_admin_app/presentation/pages/ads_page/ads_page.dart';
import 'package:gas_admin_app/presentation/pages/ads_page/ads_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/auth/login_page/login_page.dart';
import 'package:gas_admin_app/presentation/pages/auth/login_page/login_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/categories_page/categories_page.dart';
import 'package:gas_admin_app/presentation/pages/categories_page/categories_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/customers/customers_page/customers_page.dart';
import 'package:gas_admin_app/presentation/pages/customers/customers_page/customers_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/delivery_fee_page/delivery_fee_controller.dart';
import 'package:gas_admin_app/presentation/pages/delivery_fee_page/delivery_fee_page.dart';
import 'package:gas_admin_app/presentation/pages/drivers/drivers_page/drivers_page.dart';
import 'package:gas_admin_app/presentation/pages/drivers/drivers_page/drivers_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/main_page/main_page.dart';
import 'package:gas_admin_app/presentation/pages/main_page/main_page_controller.dart';
import 'package:gas_admin_app/presentation/pages/products_page/products_page.dart';
import 'package:gas_admin_app/presentation/pages/products_page/products_page_controller.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/presentation/pages/splash_page/splash_page.dart';
import 'package:gas_admin_app/presentation/pages/splash_page/splash_page_controller.dart';

abstract class NavigationManager {
  static final getPages = [
    // GetPage(
    //   name: AppRoutes.deepLinkMeal,
    //   page: () {
    //     int mealId = -1;
    //     Future.delayed(const Duration(milliseconds: 100), () {});
    //     if (Get.parameters['id'] != null) {
    //       mealId = int.parse(Get.parameters['id']!);
    //     }
    //     return SplashPage(
    //       deepLinkMeal: mealId,
    //       deepLinkPerson: -1,
    //     );
    //   },
    // ),
    GetPage(
      name: AppRoutes.splashRoute,
      page: () => SplashPage(),
      binding: BindingsBuilder.put(() => SplashPageController()),
    ),
    GetPage(
      name: AppRoutes.mainRoute,
      page: () => MainPage(),
      binding: BindingsBuilder.put(() => MainController()),
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => LoginPage(),
      binding: BindingsBuilder.put(() => LoginPageController()),
    ),

    GetPage(
      name: AppRoutes.adsRoute,
      page: () => AdsPage(),
      binding: BindingsBuilder.put(() => AdsPageController()),
    ),

    GetPage(
      name: AppRoutes.productsRoute,
      page: () => ProductsPage(),
      binding: BindingsBuilder.put(() => ProductsPageController()),
    ),
    GetPage(
      name: AppRoutes.categoriesRoute,
      page: () => CategoriesPage(),
      binding: BindingsBuilder.put(() => CategoriesPageController()),
    ),
    GetPage(
      name: AppRoutes.driversRoute,
      page: () => DriversPage(),
      binding: BindingsBuilder.put(() => DriversPageController()),
    ),
    GetPage(
      name: AppRoutes.customersRoute,
      page: () => CustomersPage(),
      binding: BindingsBuilder.put(() => CustomersPageController()),
    ),
    GetPage(
      name: AppRoutes.deliveryFeeRoute,
      page: () => DeliveryFeePage(),
      binding: BindingsBuilder.put(() => DeliveryFeePageController()),
    ),
  ];
}

abstract class AppRoutes {
  static const String splashRoute = "/";
  static const String mainRoute = "/main";
  static const String homeRoute = "/home";
  static const String loginRoute = "/login";
  static const String registrationRoute = "/registration";
  static const String mangeAccountRoute = "/mangeAccount";
  static const String adsRoute = "/adsRoute";
  static const String addReviewRoute = "/addReviewRoute";
  static const String addOrderRoute = "/addOrderRoute";
  static const String myOrderRoute = "/myOrderRoute";
  static const String productsRoute = "/productsRoute";
  static const String categoriesRoute = "/categoriesRoute";

  static const String driversRoute = "/driversRoute";

  static const String customersRoute = "/customersRoute";
  static const String deliveryFeeRoute = "/deliveryFeeRoute";
}
