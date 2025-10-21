import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/data/enums/loading_state_enum.dart';
import 'package:gas_admin_app/data/repos/users_repo.dart';
import 'package:gas_admin_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_admin_app/presentation/util/resources/navigation_manager.dart';

class ResetPasswordPageController extends GetxController {
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmationController = TextEditingController();
  final resetPasswordLoadingState = LoadingState.idle.obs;
  final isNewPassword = false.obs;
  final isConfirmPassword = false.obs;

  String? phoneNumber = Get.arguments['phoneNumber'];
  String? pin = Get.arguments['pin'];

  Future resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    if (resetPasswordLoadingState.value == LoadingState.loading) return;
    resetPasswordLoadingState.value = LoadingState.loading;

    final response = await usersRepo.resetPassword(
      phoneNumber: phoneNumber?.replaceAll(RegExp(r'[^0-9+]'), '') ?? '',
      pin: pin ?? '',
      newPassword: newPasswordController.text,
      newPasswordConfirmation: newPasswordConfirmationController.text,
    );

    if (!response.success) {
      resetPasswordLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    CustomToasts(
      message: response.successMessage ?? 'ResetPasswordSuccess'.tr,
      type: CustomToastType.success,
    ).show();

    Get.offAllNamed(AppRoutes.loginRoute);

    resetPasswordLoadingState.value = LoadingState.doneWithData;
  }
}
