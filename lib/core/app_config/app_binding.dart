import 'package:gas_admin_app/data/repos/ads_repo.dart';
import 'package:gas_admin_app/data/repos/customer_repo.dart';
import 'package:gas_admin_app/data/repos/delivery_fee_repo.dart';
import 'package:gas_admin_app/data/repos/driver_repo.dart';
import 'package:gas_admin_app/data/repos/orders_repo.dart';
import 'package:gas_admin_app/data/repos/products_repo.dart';
import 'package:gas_admin_app/data/repos/users_repo.dart';
import 'package:gas_admin_app/presentation/pages/customers/customers_page/customers_page.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/core/services/cache_service.dart';
import 'package:gas_admin_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_admin_app/core/services/permission_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CacheService());
    Get.put(ApiService());
    // Get.put(DeepLinkService());
    Get.put(UsersRepo());
    Get.put(DriversRepo());
    Get.put(CustomersRepo());
    Get.put(PermissionService());
    Get.put(DeliveryFeeRepo());
    Get.put(AdsRepo());
    Get.put(OrderRepo());
    Get.put(ProductsRepo());
  }
}
