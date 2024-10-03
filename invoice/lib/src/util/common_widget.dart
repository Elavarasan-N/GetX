import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/config/app_colors.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:invoice/src/app.dart';

Widget customDialog({
  double? borderRadius,
  Widget? content,
  Widget? title,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? titlePadding = EdgeInsets.zero,
  List<Widget>? actions,
  Widget? displayUnderLogo,
  Color? backgroundColor = Colors.white,
  EdgeInsets? insetPadding,
  bool? scrollable = true,
}) {
  return AlertDialog(
    surfaceTintColor: Colors.white,
    title: title,
    titlePadding: titlePadding,
    contentPadding: contentPadding,
    backgroundColor: backgroundColor!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          borderRadius ?? 5.scale,
        ),
      ),
    ),
    content: content,
    actions: actions,
    buttonPadding: EdgeInsets.zero,
    scrollable: scrollable ?? true,
  );
}

void showSnackBar({
  required String title,
  required String message,
  required ContentType contentType,
}) {
  MyApp.snackbarKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
}

void getXSnackBar({
  required String title,
  required String message,
}) {
  Get.snackbar(
    title,
    message,
    maxWidth: 400.scale,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.darkRed, 
    colorText: AppColors.white,
    borderRadius: 12.scale, 
    margin: EdgeInsets.all(10.scale), 
    animationDuration: const Duration(milliseconds: 800),
    duration: const Duration(seconds: 4), 
    forwardAnimationCurve: Curves.easeInOut, 
    reverseAnimationCurve: Curves.easeInOut,
    snackStyle: SnackStyle.FLOATING, 
    boxShadows: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.3), 
        spreadRadius: 1,
        blurRadius: 6,
        offset: const Offset(2, 2),
      ),
    ],
    isDismissible: true, 
    dismissDirection: DismissDirection.horizontal, 
    icon: const Icon(Icons.error_outline, color: AppColors.white),
  );
}

Widget buildActionButton({
  required String label, 
  required Color color, 
  required VoidCallback onPressed,
}) {
  return Container(
    constraints: BoxConstraints(maxWidth: 55.scale, maxHeight: 20.scale),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: color,
      boxShadow: const [
        BoxShadow(
          blurRadius: 1.1,
          color: Colors.black45,
          spreadRadius: 0.5,
          offset: Offset(1.5, 2),
        ),
      ],
    ),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: globalStyle.text.btn2.copyWith(color: AppColors.white),
      ),
    ),
  );
}
