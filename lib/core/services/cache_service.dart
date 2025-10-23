import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gas_admin_app/data/models/user_model.dart';

const kUserLoginModelKey = "kUserLoginModelKey";
const kUserTokenKey = "kUserTokenKey";
const kStoreIdKey = "kStoreIdKey";
const kRefreshTokenKey = "kRefreshTokenKey";
const kFCMTokenKey = "kFCMTokenKey";
const kPushNotification = "kPushNotificationKey";
const kLanguageCode = "kLanguageCode";
const kCurrentAccountModeCode = "kCurrentAccountModeCode";
const kCartItemsKey = "kCartItemsKey";

class CacheService extends GetxService {
  late GetStorage _getStorage;

  CacheService() {
    _getStorage = GetStorage();
  }

  Future<void> saveLanguage(String languageCode) async {
    await _getStorage.write(kLanguageCode, languageCode);
  }

  String getLanguage() => _getStorage.read(kLanguageCode) ?? 'ar';

  bool isLoggedIn() => _getStorage.hasData(kUserLoginModelKey);

  int? getStoreId() => _getStorage.read(kStoreIdKey);

  void deleteCurrentUserAndToken() {
    _getStorage.remove(kUserLoginModelKey);
    _getStorage.remove(kUserTokenKey);
    _getStorage.remove(kStoreIdKey);
    _getStorage.remove(kCartItemsKey);
  }

  Future updateUserInfo(UserModel user) async {
    await _getStorage.write(kUserLoginModelKey, user.toRawJson());
  }

  Future storeLoggedInUserAndToken(UserModel user, String token) async {
    await _getStorage.write(kUserLoginModelKey, user.toRawJson());
    await _getStorage.write(kUserTokenKey, token);
  }

  UserModel getLoggedInUser() {
    final result = _getStorage.read(kUserLoginModelKey);
    if (result == null) {
      return UserModel.emptyUser();
    }
    return UserModel.fromRawJson(result);
  }

  Future storeUserToken(String token) async {
    await _getStorage.write(kUserTokenKey, token);
  }

  Future<String> getUserToken() async {
    String? token = _getStorage.read(kUserTokenKey);
    return token ?? "";
  }

  Future storeUserRefreshToken(String refreshToken) async {
    await _getStorage.write(kRefreshTokenKey, refreshToken);
  }

  Future<String> getUserRefreshToken() async {
    String? refreshToken = _getStorage.read(kRefreshTokenKey);
    return refreshToken ?? "";
  }

  void storeFCMToken(String fCMToken) {
    _getStorage.write(kFCMTokenKey, fCMToken);
  }

  String? getFCMToken() {
    return _getStorage.read(kFCMTokenKey);
  }

  void storePushNotification(bool pushNotification) {
    _getStorage.write(kPushNotification, pushNotification);
  }

  bool? getPushNotification() {
    return _getStorage.read(kPushNotification);
  }

  Future clearCache() async {
    await _getStorage.erase();
  }

  // Cart Management






}
