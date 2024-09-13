import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/config/app_colors.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:invoice/config/asset_contants.dart';
import 'package:invoice/config/sized_boxes.dart';
import 'package:invoice/config/strings.dart';
import 'package:invoice/src/pages/home/application/home_controller.dart';
import 'package:invoice/src/pages/home/ui/popup/add_item.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.scale),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Text(
                  Strings.skfoods.toUpperCase(),
                  style: globalStyle.text.h3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width10,
                Image.asset(
                  AssetContants.companyLogo,
                  height: 80.scale,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${Strings.date} ${Strings.colon} ',
                  style: globalStyle.text.btn1,
                ),
                SizedBox(
                  height: 30.scale,
                  width: 140.scale,
                  child: InkWell(
                    onTap: () async {
                      final DateTime? selected = await showDatePicker(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDatePickerMode: DatePickerMode.day,
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hintColor: AppColors.white,
                              colorScheme: const ColorScheme.light(
                                  primary: AppColors.darkBlue),
                              buttonTheme: const ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (selected != null) {
                        controller.selectedDate.value =
                            DateFormat('MMMM dd, yyyy').format(selected);
                        controller.update();
                      }
                    },
                    child: Center(
                      child: Obx(
                        () => Text(
                          controller.selectedDate.isEmpty
                              ? controller.todayDate
                              : controller.selectedDate.value,
                          style: globalStyle.text.btn.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            height40,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Strings.billTo} ${Strings.colon}',
                      style: globalStyle.text.btn.copyWith(
                        fontSize: 18.scale,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${Strings.companyName} ${Strings.colon} ',
                          style: globalStyle.text.btn1,
                        ),
                        SizedBox(
                          height: 30.scale,
                          width: 240.scale,
                          child: TextFormField(
                            controller: controller.cname,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z.]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Strings.enterCompanyName,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.scale),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${Strings.address} ${Strings.colon} ',
                          style: globalStyle.text.btn1,
                        ),
                        SizedBox(
                          height: 30.scale,
                          width: 180.scale,
                          child: TextFormField(
                            controller: controller.address,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Strings.enterAddress,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.scale),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${Strings.pincode} ${Strings.colon} ',
                          style: globalStyle.text.btn1,
                        ),
                        SizedBox(
                          height: 30.scale,
                          width: 180.scale,
                          child: TextFormField(
                            controller: controller.pincode,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Strings.enterPincode,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.scale),
                            ),
                          ),
                        ),
                      ],
                    ),
                    height10,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.darkBlue,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 1.1,
                            color: Colors.black45,
                            spreadRadius: 0.5,
                            offset: Offset(
                              1.5,
                              2,
                            ),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.dialog(
                            AddItem(
                              controller: controller,
                              isEdit: false,
                              index: 0,
                            ),
                            barrierDismissible: false,
                          );
                        },
                        child: Text(
                          Strings.addItem,
                          style: globalStyle.text.btn.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Strings.paymentInformation} ${Strings.colon}',
                      style: globalStyle.text.btn.copyWith(
                        fontSize: 18.scale,
                      ),
                    ),
                    height7,
                    Row(
                      children: [
                        Text(
                          '${Strings.bank} ${Strings.colon} ',
                          style: globalStyle.text.btn1,
                        ),
                        SizedBox(
                          height: 30.scale,
                          width: 180.scale,
                          child: TextFormField(
                            controller: controller.bank,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Strings.enterBankName,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.scale),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${Strings.name} ${Strings.colon} ',
                          style: globalStyle.text.btn1,
                        ),
                        SizedBox(
                          height: 30.scale,
                          width: 180.scale,
                          child: TextFormField(
                            controller: controller.name,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Strings.enterName,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.scale),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${Strings.account} ${Strings.colon} ',
                          style: globalStyle.text.btn1,
                        ),
                        SizedBox(
                          height: 30.scale,
                          width: 180.scale,
                          child: TextFormField(
                            controller: controller.account,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Strings.enterAccountNumber,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.scale),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            height12,
            Obx(() => Column(
              children: [
                Table(
                  border: TableBorder.all(
                    color: AppColors.black,
                    width: 1.scale,
                  ),
                  children: [
                    header(),
                  ],
                ),
                SizedBox(
                  height: 200.scale,
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Table(
                      border: TableBorder.all(
                        color: AppColors.black,
                        width: 1.scale,
                      ),
                      children: [
                        for (int i = 0; i < controller.cartItem.length; i++) 
                          cartItem(
                            sno: i + 1,
                            date: controller.cartItem[i].date ?? '',
                            item: controller.cartItem[i].item ?? '',
                            qty: '${controller.cartItem[i].qty}',
                            rate: controller.cartItem[i].unit!.isEmpty
                                ? '${controller.cartItem[i].unitPrice}'
                                : '${controller.cartItem[i].unitPrice}/${controller.cartItem[i].unit}',
                            amount: '${controller.cartItem[i].qty! * controller.cartItem[i].unitPrice!}',
                          ),
                      ],
                    ),
                  ),
                ),
              ]
            )),
            height40,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.scale),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.darkBlue,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${Strings.total.toUpperCase()} ${Strings.colon} ',
                        style: globalStyle.text.btn.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Obx(
                        () => Text(
                          'Rs.${controller.grandTotal.value}/-',
                          style: globalStyle.text.btn.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height30,
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.green),
              ),
              onPressed: () {
                controller.save(context: context);
              },
              child: Text(
                Strings.saveAsPdf,
                style: globalStyle.text.btn.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow header() {
    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.sno,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.date.toUpperCase(),
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.item.toUpperCase(),
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.qty.toUpperCase(),
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.rate.toUpperCase(),
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.amount.toUpperCase(),
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.scale, 10.scale, 5.scale, 10.scale),
          child: Text(
            Strings.actions.toUpperCase(),
            textAlign: TextAlign.center,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  TableRow cartItem({
    required int sno,
    required String date,
    required String item,
    required String qty,
    required String rate,
    required String amount,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.scale),
          child: Text(
            '$sno',
            textAlign: TextAlign.center,
            style: globalStyle.text.btn1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.scale),
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: globalStyle.text.btn1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.scale),
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: globalStyle.text.btn1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.scale),
          child: Text(
            qty,
            textAlign: TextAlign.center,
            style: globalStyle.text.btn1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.scale),
          child: Text(
            'Rs.$rate',
            textAlign: TextAlign.center,
            style: globalStyle.text.btn1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.scale),
          child: Text(
            'Rs.$amount',
            textAlign: TextAlign.center,
            style: globalStyle.text.btn1,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.scale),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  controller.editItem(index: sno - 1);
                },
                icon: const Icon(Icons.edit_rounded),
              ),
              IconButton(
                onPressed: () {
                  controller.deleteItem(index: sno - 1);
                },
                icon: const Icon(Icons.delete_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
