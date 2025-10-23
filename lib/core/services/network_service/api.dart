abstract class Api {
  static const String imageBaseUrl = "http://10.0.2.2:8000/storage/";

  /// Authentication
  static const String register = "auth/register/driver";
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String verify = "auth/customer/verify";
  static const String resendPin = "auth/customer/resend-pin";
  static const String forgetPassword = 'auth/customer/forgot-password';
  static const String verifyResetPin = 'auth/customer/verify-reset-pin';
  static const String resetPassword = 'auth/customer/reset-password';

  /// Products
  static const String products = "products";

  /// Ads
  static const String ads = "ads";

  /// drivers
  static const String drivers = "drivers";

  ///Categories
  static const String categories = "categories";

  ///Orders
  static const String orders = "customer/orders";
  static const String myOrders = "customer/my-orders";

  ///Delivery Fees
  static const String deliveryFee = "delivery-fee";
}
