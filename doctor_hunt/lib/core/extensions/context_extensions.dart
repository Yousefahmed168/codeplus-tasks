// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// import '../enums/snack_bar.dart';
// import '../themes/app_colors.dart';

// extension ThemeExtentions on BuildContext {
//   Color get primaryColor => Theme.of(this).primaryColor;

//   Color get scaffoldColor => Theme.of(this).scaffoldBackgroundColor;
// }

// extension Navigate on StackRouter {
//   Future<bool> popSafe() async {
//     if (canPop()) {
//       return maybePop();
//     }
//     return false;
//   }

//   Future push(PageRouteInfo route) async {
//     return this.push(route);
//   }

//   Future pushAndPopUntil(
//     PageRouteInfo route,
//     bool Function(Route route) predicate,
//   ) async {
//     return this.pushAndPopUntil(route, predicate: predicate);
//   }

//   Future pushAndPopAll(PageRouteInfo route) {
//     return pushAndPopUntil(route, (route) => false);
//   }

//   ModalRoute currentRoute(BuildContext context) => ModalRoute.of(context)!;
// }

// extension ContextExtentions on BuildContext {
//   StackRouter get navigator => AutoRouter.of(this);

//   // bool get canPop {
//   //   final currentRoute = ModalRoute.of(this)?.settings.name;
//   //   final isLastPage = currentRoute == RouteNames.bottomNavBar ||
//   //       currentRoute == RouteNames.auth;
//   //   return navigator.canPop() && !isLastPage;
//   // }

//   void pop() {
//     navigator.popSafe();
//   }

//   Future push(PageRouteInfo route) async => navigator.push(route);
//   Future popAndPush(PageRouteInfo route) async => navigator.popAndPush(route);

//   Future pushAndPopUntil(
//     PageRouteInfo route,
//     bool Function(Route route) predicate,
//   ) async =>
//       navigator.pushAndPopUntil(route, predicate: predicate);

//   Future pushAndPopAll(PageRouteInfo route) async =>
//       navigator.pushAndPopAll(route);

//   ModalRoute get currentRoute => navigator.currentRoute(this);
// }

// extension ScreenExtentions on BuildContext {
//   double get width => MediaQuery.of(this).size.width;

//   double get height => MediaQuery.of(this).size.height;

//   double get aspectRatio => MediaQuery.of(this).size.aspectRatio;

//   EdgeInsets get padding => MediaQuery.of(this).padding;

//   void requestFocus([FocusNode? node]) =>
//       FocusScope.of(this).requestFocus(node);

//   void requestNewFocusNode() => requestFocus(FocusNode());
// }

// extension CustomDialog on BuildContext {
//   Future showCustomDialog({required Widget content}) => showDialog(
//         context: this,
//         builder: (context) => Dialog(
//           backgroundColor: AppColors.white,
//           surfaceTintColor: AppColors.white,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           child: Padding(padding: const EdgeInsets.all(20), child: content),
//         ),
//       );
// }

// extension CustomSnackBar on BuildContext {
//   Color getSnackBarColor(SnackBarStatus snackBarStatus) {
//     late Color bgColor;
//     if (snackBarStatus == SnackBarStatus.success) {
//       bgColor = AppColors.success;
//     } else if (snackBarStatus == SnackBarStatus.error) {
//       bgColor = AppColors.danger;
//     } else {
//       bgColor = AppColors.warning;
//     }
//     return bgColor;
//   }
//   // Future<void> showCustomSnackBar({
//   //   required String message,
//   //   SnackBarStatus snackBarStatus = SnackBarStatus.error,
//   // }) async {
//   //   final Color bgColor = getSnackBarColor(snackBarStatus);
//   //   ScaffoldMessenger.of(this).clearSnackBars();
//   //   ScaffoldMessenger.of(this).showSnackBar(
//   //     SnackBar(
//   //       behavior: SnackBarBehavior.floating,
//   //       backgroundColor: bgColor,
//   //       content: Text(
//   //         message,
//   //         style: regular14White,
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// extension ShowBottomSheet on BuildContext {
//   void showBottomSheet({
//     required Widget bottomSheetBody,
//     bool isDismissible = true,
//     Color backgroundColor = AppColors.white,
//   }) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       useSafeArea: true,
//       context: this,
//       isDismissible: isDismissible,
//       builder: (context) => Container(
//         width: width,
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         constraints: BoxConstraints(
//           maxHeight: height * .9,
//           // minHeight: height * .4,
//         ),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: width * .30,
//                 height: 6,
//                 margin: const EdgeInsets.symmetric(vertical: 20),
//                 decoration: BoxDecoration(
//                   color: AppColors.black,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               bottomSheetBody,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension ShowAlertDialog on BuildContext {
//   Future<void> showCustomAlertDialog({
//     required Widget dialog,
//     bool barrierDismissible = false,
//   }) async {
//     return showDialog(
//       context: this,
//       barrierDismissible: barrierDismissible,
//       builder: (context) => AlertDialog(
//         content: dialog,
//         backgroundColor: AppColors.white,
//         surfaceTintColor: AppColors.white,
//       ),
//     );
//   }
// }

// extension IntExtensions on int {
//   String get formatCount {
//     if (this >= 1000) {
//       return '${(this / 1000).toStringAsFixed(this % 1000 == 0 ? 0 : 1)}k';
//     }
//     return toString();
//   }
// }
