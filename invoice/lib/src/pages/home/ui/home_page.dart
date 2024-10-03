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
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.scale, right: 40.scale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.scale, top: 20.scale),
              child: Row(
                children: [
                  Text(
                    '${Strings.date} ${Strings.colon} ',
                    style: globalStyle.text.btn1,
                  ),
                  SizedBox(
                    height: 30.scale,
                    width: 120.scale,
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
            ),
            height20,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: billingInformationSection(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: paymentInformationSection(),
                  ),
                ],
              ),
            ),
            height10,
            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width + 40,
                        child: Table(
                          border: TableBorder.all(
                            color: AppColors.black,
                            width: 1.scale,
                          ),
                          children: [
                            tableHeader(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width + 40,
                            child: Table(
                              border: TableBorder.all(
                                color: AppColors.black,
                                width: 1.scale,
                              ),
                              children: [
                                for (int i = 0;
                                    i < controller.cartItem.length;
                                    i++)
                                  cartItemRow(index: i),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            height20,
            totalAmountSection(),
            height20,
            saveAsPdfButton(context),
          ],
        );
      }),
    );
  }

  Widget billingInformationSection() {
    return Padding(
      padding: EdgeInsets.only(left: 10.scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Strings.billTo} ${Strings.colon}',
            style: globalStyle.text.btn,
          ),
          height5,
          customTextField(
            Strings.companyName,
            Strings.enterCompanyName,
            controller.cname,
          ),
          height2,
          customTextField(
            Strings.address,
            Strings.enterAddress,
            controller.address,
          ),
          height2,
          customTextField(
            Strings.pincode,
            Strings.pincode,
            controller.pincode,
            maxLength: 10,
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
                style: globalStyle.text.btn1.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentInformationSection() {
    return Padding(
      padding: EdgeInsets.only(right: 10.scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Strings.paymentInformation} ${Strings.colon}',
            style: globalStyle.text.btn,
          ),
          height5,
          customTextField(
            Strings.bankName,
            Strings.enterBankName,
            controller.bank,
          ),
          height2,
          customTextField(
            Strings.accountName,
            Strings.enterName,
            controller.name,
            maxLength: 20,
          ),
          height2,
          customTextField(
            Strings.accountNo,
            Strings.enterAccountNumber,
            controller.account,
            maxLength: 15,
            isNumber: true,
          ),
        ],
      ),
    );
  }

  Widget customTextField(
    String label,
    String hintText,
    TextEditingController textController, {
    int maxLength = 30,
    bool isNumber = false,
  }) {
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
          padding: EdgeInsets.only(left: 3.scale, bottom: 3.scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: AppColors.grey,
              width: 1,
            ),
          ),
          height: 20.scale,
          width: 140.scale,
          child: TextFormField(
            controller: textController,
            textAlign: TextAlign.start,
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
            ),
          ),
        ),
      ],
    );
  }

  TableRow tableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
      ),
      children: [
        tableHeaderCell(Strings.sno),
        tableHeaderCell(Strings.date.toUpperCase()),
        tableHeaderCell(Strings.item.toUpperCase()),
        tableHeaderCell(Strings.qty.toUpperCase()),
        tableHeaderCell(Strings.rate.toUpperCase()),
        tableHeaderCell(Strings.amount.toUpperCase()),
        tableHeaderCell(Strings.actions.toUpperCase()),
      ],
    );
  }

  TableRow cartItemRow({required int index}) {
    return TableRow(
      children: [
        tableCellRow('${index + 1}'),
        tableCellRow(controller.cartItem[index].date ?? ''),
        tableCellRow(controller.cartItem[index].item ?? ''),
        tableCellRow('${controller.cartItem[index].qty}'),
        tableCellRow('Rs.${controller.cartItem[index].unitPrice}'),
        tableCellRow(
            'Rs.${controller.cartItem[index].qty! * controller.cartItem[index].unitPrice!}'),
        tableCellActions(index),
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
      padding: EdgeInsets.only(top: 8.scale, bottom: 5.scale),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: globalStyle.text.btn2,
      ),
    );
  }

  Widget tableCellActions(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            controller.editItem(index: index);
          },
          icon: const Icon(
            Icons.edit_rounded,
            size: 16,
          ),
        ),
        IconButton(
          onPressed: () {
            controller.deleteItem(index: index);
          },
          icon: const Icon(
            Icons.delete_rounded,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget totalAmountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30.scale,
          width: 120.scale,
          padding: EdgeInsets.only(left: 15.scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.darkBlue,
          ),
          child: Row(
            children: [
              Text(
                '${Strings.total} ${Strings.colon} ',
                style: globalStyle.text.btn.copyWith(color: AppColors.white),
              ),
              Obx(
                () => Text(
                  'Rs. ${controller.grandTotal.value}',
                  style: globalStyle.text.btn.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget saveAsPdfButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.cartItem.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.darkRed,
              content: Text(
                Strings.noItems,
                style: globalStyle.text.btn.copyWith(color: AppColors.white),
              ),
            ),
          );
        } else {
          controller.save(context: context);
        }
      },
      child: Container(
        height: 30.scale,
        width: 120.scale,
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(10.scale),
        ),
        child: Center(
          child: Text(
            Strings.saveAsPdf,
            style: globalStyle.text.btn.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
