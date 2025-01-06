import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/config/app_colors.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:invoice/config/sized_boxes.dart';
import 'package:invoice/config/strings.dart';
import 'package:invoice/src/pages/home/application/home_controller.dart';
import 'package:invoice/util/common_widget.dart';

class AddItem extends StatelessWidget {
  final HomeController controller;
  final bool isEdit;
  final int index;
  const AddItem({
    super.key,
    required this.controller,
    required this.isEdit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return customDialog(
      titlePadding: EdgeInsets.only(top: 10.scale),
      title: Column(
        children: [
          Text(
            Strings.addItem.toUpperCase(),
            style: globalStyle.text.btn.copyWith(
              fontSize: 18,
            ),
          ),
          Divider(
            height: 1.scale,
            color: AppColors.darkBlue,
          ),
        ],
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${Strings.date} ${Strings.colon}  ',
                style: globalStyle.text.btn2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 120.scale,
                  maxHeight: 25.scale,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: AppColors.grey,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    final DateTime? selected = await showDatePicker(
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDatePickerMode: DatePickerMode.day,
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2024, DateTime.now().month + 1, 0),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hintColor: AppColors.white,
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.darkBlue,
                            ),
                            buttonTheme: const ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selected != null) {
                      controller.itemDate.value =
                          DateFormat('dd-MM-yy').format(selected);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        5.scale, 6.scale, 60.scale, 6.scale),
                    child: Obx(
                      () => Text(
                        controller.itemDate.isEmpty
                            ? controller.itemTodayDate
                            : controller.itemDate.value,
                        style: globalStyle.text.btn2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          height5,
          popupTextField(
            '${Strings.item} ${Strings.colon}  ',
            Strings.itemName,
            context,
            controller.item,
          ),
          height5,
          popupTextField(
            '${Strings.qty}   ${Strings.colon}  ',
            Strings.quantity,
            context,
            controller.qty,
            isNumber: true,
          ),
          height5,
          popupTextField(
            '${Strings.rate} ${Strings.colon}  ',
            Strings.rateInRuppees,
            context,
            controller.rate,
            isNumber: true,
          ),
          height5,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${Strings.unit} ${Strings.colon}  ',
                style: globalStyle.text.btn2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => Container(
                  constraints: BoxConstraints(
                    maxWidth: 120.scale,
                    maxHeight: 25.scale,
                  ),
                  margin: EdgeInsets.only(left: 0.5.scale),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: AppColors.grey,
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.black,
                        size: 20.scale,
                      ),
                      hint: Padding(
                        padding: EdgeInsets.only(left: 4.scale),
                        child: Text(
                          controller.selectedUnit.value.isEmpty
                              ? controller.unit[0]
                              : controller.selectedUnit.value,
                          style: globalStyle.text.btn2.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      style: globalStyle.text.btn2.copyWith(
                        color: AppColors.black,
                      ),
                      items: controller.unit
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        controller.selectedUnit.value = val!;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          height15,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildActionButton(
                label: isEdit ? Strings.update : Strings.add,
                context,
                color: AppColors.darkBlue,
                onPressed: () {
                  if (validateInputs()) {
                    if (isEdit) {
                      controller.updateItem(
                        index: index,
                        date: controller.itemDate.value,
                        item: controller.item.text,
                        qty: int.tryParse(controller.qty.text) ?? 0,
                        rate: int.tryParse(controller.rate.text) ?? 0,
                        unit: controller.selectedUnit.value,
                      );
                    } else {
                      controller.addItem(
                        date: controller.itemDate.value,
                        item: controller.item.text,
                        qty: int.tryParse(controller.qty.text) ?? 0,
                        rate: int.tryParse(controller.rate.text) ?? 0,
                        unit: controller.selectedUnit.value,
                      );
                    }
                    Get.back();
                  }
                },
              ),
              buildActionButton(
                label: Strings.close,
                context,
                color: AppColors.red,
                onPressed: () {
                  controller.clearText();
                  controller.selectedUnit.value = '';
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool validateInputs() {
    if (controller.item.text.isEmpty) {
      getXSnackBar(
        title: Strings.warning,
        message: Strings.itemCannotBeEmpty,
      );
      return false;
    }
    if (controller.qty.text.isEmpty || int.tryParse(controller.qty.text) == 0) {
      getXSnackBar(
        title: Strings.warning,
        message: Strings.quantityMustBeGreaterThanZero,
      );
      return false;
    }
    if (controller.rate.text.isEmpty ||
        int.tryParse(controller.rate.text) == 0) {
      getXSnackBar(
        title: Strings.warning,
        message: Strings.rateMustBeGreaterThanZero,
      );
      return false;
    }
    return true;
  }
}
