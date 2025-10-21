import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // margin: const EdgeInsets.all(AppPadding.p8),
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.12),
              offset: Offset(0, 3),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p24,
            horizontal: AppPadding.p10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CardAdsPhonePageTitle".tr,
                style: TextStyle(
                  color: ColorManager.colorFontPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s16,
                ),
              ),
              const SizedBox(height: AppSize.s16),
              buildListItem("CardAdsPhonePageDes1".tr),
              buildListItem("CardAdsPhonePageDes2".tr),
              buildListItem("CardAdsPhonePageDes3".tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorDoveGray600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_admin_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_admin_app/presentation/util/resources/values_manager.dart';

// class InfoCard extends StatelessWidget {
//   const InfoCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.all(AppPadding.p14),
//         width: AppSize.sWidth,
//         decoration: BoxDecoration(
//           color: ColorManager.colorWhite,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withValues(alpha: 0.12),
//               offset: Offset(0, 2),
//               spreadRadius: 1,
//               blurRadius: 3,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with icon
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(AppPadding.p8),
//                   decoration: BoxDecoration(
//                     color: ColorManager.colorPrimary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.verified_rounded,
//                     color: ColorManager.colorPrimary,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: AppSize.s12),
//                 Expanded(
//                   child: Text(
//                     "CardAdsPhonePageTitle".tr,
//                     style: TextStyle(
//                       color: ColorManager.colorFontPrimary,
//                       fontWeight: FontWeight.w700,
//                       fontSize: FontSize.s18,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: AppSize.s20),

//             // Divider
//             Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.grey.shade300,
//                     Colors.grey.shade100,
//                     Colors.grey.shade300,
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: AppSize.s20),

//             // List items
//             buildListItem("CardAdsPhonePageDes1".tr, 0),
//             buildListItem("CardAdsPhonePageDes2".tr, 1),
//             buildListItem("CardAdsPhonePageDes3".tr, 2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildListItem(String text, int index) {
//     final List<Color> iconColors = [
//       Colors.green.shade500,
//       Colors.blue.shade500,
//       Colors.orange.shade500,
//     ];

//     final List<IconData> icons = [
//       Icons.security_rounded,
//       Icons.phone_iphone_rounded,
//       Icons.rocket_launch_rounded,
//     ];

//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300 + (index * 100)),
//       curve: Curves.easeInOut,
//       margin: const EdgeInsets.symmetric(vertical: AppPadding.p8),
//       padding: const EdgeInsets.all(AppPadding.p12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12.withOpacity(0.05),
//             offset: const Offset(0, 2),
//             blurRadius: 4,
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade100, width: 1),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(AppPadding.p8),
//             decoration: BoxDecoration(
//               color: iconColors[index].withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icons[index], color: iconColors[index], size: 20),
//           ),
//           const SizedBox(width: AppSize.s12),
//           Expanded(
//             child: Text(
//               text,
//               style: Get.textTheme.bodyMedium?.copyWith(
//                 color: ColorManager.colorDoveGray600,
//                 fontWeight: FontWeight.w500,
//                 fontSize: FontSize.s14,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
