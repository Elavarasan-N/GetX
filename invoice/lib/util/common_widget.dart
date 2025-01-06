import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invoice/config/app_colors.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:invoice/config/strings.dart';
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

Widget customTextField(
  String label,
  String hintText,
  BuildContext context,
  TextEditingController textController, {
  int maxLength = 30,
  bool isNumber = false,
}) {
  var size = MediaQuery.of(context).size;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '$label ${Strings.colon} ',
        style: globalStyle.text.btn2.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 3.scale),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: AppColors.grey,
            width: 1,
          ),
        ),
        constraints: BoxConstraints(maxWidth: 180.scale, maxHeight: 20.scale),
        child: TextFormField(
          controller: textController,
          textAlign: TextAlign.start,
          style: globalStyle.text.btn2,
          inputFormatters: isNumber
              ? [
                  LengthLimitingTextInputFormatter(maxLength),
                  FilteringTextInputFormatter.digitsOnly
                ]
              : [LengthLimitingTextInputFormatter(maxLength)],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: globalStyle.text.btn2,
            contentPadding: size.height < 640
                ? EdgeInsets.symmetric(vertical: 17.scale)
                : EdgeInsets.symmetric(vertical: 10.5.scale),
          ),
        ),
      ),
    ],
  );
}

Widget popupTextField(
  String label,
  String hintText,
  BuildContext context,
  TextEditingController textController, {
  int maxLength = 30,
  bool isNumber = false,
}) {
  var size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        textAlign: TextAlign.center,
        style: globalStyle.text.btn2.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 3.scale),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: AppColors.grey,
            width: 1,
          ),
        ),
        constraints: BoxConstraints(maxWidth: 120.scale, maxHeight: 25.scale),
        child: TextFormField(
          controller: textController,
          textAlign: TextAlign.start,
          style: globalStyle.text.btn2,
          inputFormatters: isNumber
              ? [
                  LengthLimitingTextInputFormatter(maxLength),
                  FilteringTextInputFormatter.digitsOnly
                ]
              : [
                  LengthLimitingTextInputFormatter(maxLength),
                  FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z]'),
                  ),
                ],
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: globalStyle.text.btn2,
              contentPadding: size.width < 640
                  ? EdgeInsets.symmetric(vertical: 17.scale)
                  : EdgeInsets.symmetric(vertical: 11.5.scale)),
        ),
      ),
    ],
  );
}

Widget tableHeaderCell(String text) {
  return Padding(
    padding: EdgeInsets.all(5.scale),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: globalStyle.text.btn2.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget tableCellRow(String text) {
  return Padding(
    padding: EdgeInsets.all(10.scale),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: globalStyle.text.btn2,
    ),
  );
}

Widget customIconButton(
  BuildContext context, {
  required Icon icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  var size = MediaQuery.of(context).size;
  double iconSize = size.width < 640 ? 10.scale : 16;
  double width = size.width < 640 ? 30.scale : 40.scale;
  return IconButton(
    onPressed: onPressed,
    alignment: Alignment.center,
    padding: EdgeInsets.all(4.scale),
    constraints: BoxConstraints(maxWidth: width, maxHeight: 25.scale),
    iconSize: iconSize,
    icon: icon,
    color: color,
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

Widget buildActionButton(
  BuildContext context, {
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(color),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.scale))),
      minimumSize: MaterialStatePropertyAll(
        Size(
          MediaQuery.of(context).size.width < 640 ? 60 : 90,
          MediaQuery.of(context).size.width < 640 ? 20 : 40,
        ),
      ),
      padding: MaterialStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width < 640 ? 6 : 12,
        ),
      ),
    ),
    child: Text(
      label,
      style: globalStyle.text.btn2.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    ),
  );
}
