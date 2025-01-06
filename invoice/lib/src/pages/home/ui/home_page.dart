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
import 'package:invoice/util/common_widget.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(10.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.scale),
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
                      height: 60.scale,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.scale),
                child: Row(
                  children: [
                    Text(
                      '${Strings.date} ${Strings.colon} ',
                      style: globalStyle.text.btn2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: 25.scale, maxWidth: 80.scale),
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
                              style: globalStyle.text.btn2.copyWith(
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
              height7,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: billingInformationSection(context),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: paymentInformationSection(context),
                    ),
                  ],
                ),
              ),
              TextButton(
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
                style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(AppColors.darkBlue),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.scale))),
                  minimumSize: MaterialStatePropertyAll(
                    Size(
                      MediaQuery.of(context).size.width < 640 ? 60 : 90,
                      MediaQuery.of(context).size.width < 640 ? 20 : 40,
                    ),
                  ),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.width < 640 ? 6 : 12,
                    ),
                  ),
                ),
                child: Text(
                  Strings.addItem,
                  textAlign: TextAlign.center,
                  style: globalStyle.text.btn2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              height10,
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
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
                              width: MediaQuery.of(context).size.width - 30,
                              child: Table(
                                border: TableBorder.all(
                                  color: AppColors.black,
                                  width: 1.scale,
                                ),
                                children: [
                                  for (int i = 0;
                                      i < controller.cartItem.length;
                                      i++)
                                    cartItemRow(index: i, context: context),
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
          ),
        );
      }),
    );
  }

  Widget billingInformationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Strings.billTo} ${Strings.colon}',
          style: globalStyle.text.btn,
        ),
        height5,
        customTextField(
          Strings.company,
          Strings.companyName,
          context,
          controller.cname,
        ),
        height2,
        customTextField(
          '${Strings.address}  ',
          Strings.companyAddress,
          context,
          controller.address,
        ),
        height2,
        customTextField(
          '${Strings.pincode}  ',
          Strings.pincode,
          context,
          controller.pincode,
          maxLength: 10,
        ),
        height10,
      ],
    );
  }

  Widget paymentInformationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Strings.paymentInformation} ${Strings.colon}',
          style: globalStyle.text.btn,
        ),
        height5,
        customTextField(
          '${Strings.bankName}      ',
          Strings.bankName,
          context,
          controller.bank,
        ),
        height2,
        customTextField(
          Strings.accountName,
          Strings.accountHolderName,
          context,
          controller.name,
          maxLength: 20,
        ),
        height2,
        customTextField(
          '${Strings.accountNo}     ',
          Strings.accountNumber,
          context,
          controller.account,
          maxLength: 15,
          isNumber: true,
        ),
        height10,
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

  TableRow cartItemRow({required int index, required BuildContext context}) {
    return TableRow(
      children: [
        tableCellRow('${index + 1}'),
        tableCellRow(controller.cartItem[index].date ?? ''),
        tableCellRow(controller.cartItem[index].item ?? ''),
        tableCellRow('${controller.cartItem[index].qty}'),
        tableCellRow('₹${controller.cartItem[index].unitPrice}'),
        tableCellRow(
            '₹${controller.cartItem[index].qty! * controller.cartItem[index].unitPrice!}'),
        tableCellActions(index, context),
      ],
    );
  }

  Widget tableCellActions(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customIconButton(
            context,
            color: AppColors.black,
            icon: const Icon(
              Icons.edit_rounded,
            ),
            onPressed: () {
              controller.editItem(index: index);
            },
          ),
          customIconButton(
            context,
            color: AppColors.red,
            onPressed: () {
              controller.deleteItem(index: index);
            },
            icon: const Icon(
              Icons.delete_rounded,
            ),
          )
        ],
      ),
    );
  }

  Widget totalAmountSection() {
    return Row(
      children: [
        Obx(() {
          String grandTotal = controller.grandTotal.value.toString();
          double totalWidth = 82.scale + (grandTotal.length * 6);
          return Container(
            margin: EdgeInsets.only(left: 10.scale),
            constraints: BoxConstraints(
              maxWidth: totalWidth,
              maxHeight: 35.scale,
            ),
            padding: EdgeInsets.fromLTRB(8.scale, 5.scale, 8.scale, 5.scale),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.darkBlue,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1.1,
                  color: Colors.black45,
                  spreadRadius: 0.5,
                  offset: Offset(1.5, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  '${Strings.total.toUpperCase()} ${Strings.colon} ',
                  style: globalStyle.text.btn2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rs. $grandTotal',
                  style: globalStyle.text.btn2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget saveAsPdfButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.scale),
      child: TextButton(
        onPressed: () {
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
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(AppColors.green),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.scale))),
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
          Strings.saveAsPdf,
          textAlign: TextAlign.center,
          style: globalStyle.text.btn2.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
