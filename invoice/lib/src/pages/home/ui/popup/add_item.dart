import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/config/app_colors.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:invoice/config/sized_boxes.dart';
import 'package:invoice/config/strings.dart';
import 'package:invoice/src/pages/home/application/home_controller.dart';
import 'package:invoice/src/util/common_widget.dart';

class AddItem extends StatelessWidget {
  final HomeController controller;
  final bool isEdit;
  final int index;
  const AddItem(
      {super.key,
      required this.controller,
      required this.isEdit,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return customDialog(
      title: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.scale, bottom: 10.scale),
            child: Text(
              Strings.addItem,
              style: globalStyle.text.btn.copyWith(
                fontSize: 18,
              ),
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
            children: [
              Text(
                '${Strings.date} ${Strings.colon} ',
                style: globalStyle.text.btn,
              ),
              SizedBox(
                height: 30.scale,
                width: 80.scale,
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
                          DateFormat('dd-MM-yyyy').format(selected);
                    }
                  },
                  child: Center(
                    child: Obx(
                      () => Text(
                        controller.itemDate.isEmpty
                            ? controller.itemTodayDate
                            : controller.itemDate.value,
                        style: globalStyle.text.btn1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${Strings.item} ${Strings.colon} ',
                style: globalStyle.text.btn,
              ),
              SizedBox(
                height: 30.scale,
                width: 130.scale,
                child: TextFormField(
                  controller: controller.item,
                  textAlign: TextAlign.start,
                  style: globalStyle.text.btn1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                    FilteringTextInputFormatter.allow(
                      RegExp('[a-zA-Z]'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Strings.enterItemName,
                    contentPadding: EdgeInsets.symmetric(vertical: -11.scale),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${Strings.qty} ${Strings.colon} ',
                style: globalStyle.text.btn,
              ),
              SizedBox(
                height: 30.scale,
                width: 160.scale,
                child: TextFormField(
                  controller: controller.qty,
                  textAlign: TextAlign.start,
                  style: globalStyle.text.btn1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Strings.enterQty,
                    contentPadding: EdgeInsets.symmetric(vertical: -11.scale),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${Strings.rate} ${Strings.colon} ',
                style: globalStyle.text.btn,
              ),
              SizedBox(
                height: 30.scale,
                width: 160.scale,
                child: TextFormField(
                  controller: controller.rate,
                  textAlign: TextAlign.start,
                  style: globalStyle.text.btn1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Strings.enterRateInRuppees,
                    contentPadding: EdgeInsets.symmetric(vertical: -11.scale),
                  ),
                ),
              ),
            ],
          ),
          Row(children: [
            Text(
              '${Strings.unit} ${Strings.colon} ',
              style: globalStyle.text.btn,
            ),
            Obx(
              () => SizedBox(
                height: 30.scale,
                width: 130.scale,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(10),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.black,
                    ),
                    hint: Padding(
                      padding: EdgeInsets.only(left: 6.scale, top: 3.scale),
                      child: Text(
                        controller.selectedUnit.value.isEmpty
                            ? controller.unit[0]
                            : controller.selectedUnit.value,
                        style: globalStyle.text.btn1.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    style: globalStyle.text.btn1.copyWith(
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
          ]),
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildActionButton(
                label: isEdit ? Strings.update : Strings.add,
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
