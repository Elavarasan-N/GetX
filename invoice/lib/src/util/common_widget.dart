import 'package:flutter/material.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
