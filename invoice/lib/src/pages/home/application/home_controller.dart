import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice/config/app_colors.dart';
import 'package:invoice/config/app_sizes.dart';
import 'package:invoice/config/asset_contants.dart';
import 'package:invoice/config/strings.dart';
import 'package:invoice/src/pages/home/ui/popup/add_item.dart';
import 'package:invoice/src/util/common_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeController extends GetxController {
  TextEditingController cname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController account = TextEditingController();
  TextEditingController item = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController rate = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString selectedDate = ''.obs;
  String todayDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  RxString itemDate = ''.obs;
  String itemTodayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  RxString selectedUnit = ''.obs;
  List<String> unit = [Strings.selectUnit, 'Kg', 'Piece', 'Cup'];
  var cartItem = <CartItem>[].obs;
  RxInt grandTotal = 0.obs;

  addItem({
    required String date,
    required String item,
    required int qty,
    required int rate,
    required String unit,
  }) {
    CartItem cart = CartItem();
    cart.date = date.isEmpty ? itemTodayDate : date;
    cart.item = item;
    cart.qty = qty;
    cart.unitPrice = rate;
    cart.totalPrice = qty * rate;
    cart.unit = unit;
    cartItem.add(cart);
    scrollToBottom();
    calculateTotal();
    selectedUnit.value = '';
    clearText();
    update();
  }

  editItem({required int index}) {
    item.text = cartItem[index].item ?? '';
    rate.text = cartItem[index].unitPrice.toString();
    qty.text = cartItem[index].qty.toString();
    selectedUnit.value = cartItem[index].unit ?? '';
    itemDate.value = cartItem[index].date ?? '';
    update();
    Get.dialog(
      AddItem(
        controller: this,
        isEdit: true,
        index: index,
      ),
      barrierDismissible: false,
    );
  }

  updateItem({
    required int index,
    required String date,
    required String item,
    required int qty,
    required int rate,
    required String unit,
  }) {
    cartItem[index].date = date;
    cartItem[index].item = item;
    cartItem[index].qty = qty;
    cartItem[index].unitPrice = rate;
    cartItem[index].totalPrice = qty * rate;
    cartItem[index].unit = unit;
    cartItem.refresh();
    calculateTotal();
    selectedUnit.value = '';
    clearText();
    update();
  }

  deleteItem({required int index}) {
    cartItem.removeAt(index);
    calculateTotal();
    update();
  }

  int calculateTotal() {
    grandTotal.value = 0;
    for (var item in cartItem) {
      grandTotal.value += item.totalPrice!;
    }
    return grandTotal.value;
  }

  clearText() {
    qty.clear();
    rate.clear();
    itemDate.value = itemTodayDate;
    item.text = '';
    selectedUnit.value = '';
    update();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  save({required BuildContext context}) {
    saveAsPdf(
      context: context,
      date: selectedDate.value.isEmpty ? todayDate : selectedDate.value,
      cname: cname.text.isEmpty ? '' : cname.text,
      caddr1: address.text.isEmpty ? '' : address.text,
      caddr2: pincode.text.isEmpty ? '' : pincode.text,
      bank: bank.text.isEmpty ? '' : bank.text,
      accName: name.text.isEmpty ? '' : name.text,
      accNo: account.text.isEmpty ? '' : account.text,
      cartItem: cartItem,
    );
  }

  saveAsPdf({
    required BuildContext context,
    required String date,
    required String cname,
    required String caddr1,
    required String caddr2,
    required String bank,
    required String accName,
    required String accNo,
    required List<CartItem> cartItem,
  }) async {
    final pdf = pw.Document();
    final companyLogo = await loadImage(AssetContants.companyLogo);
    const int itemPerPage = 18;

    for (int pageIndex = 0;
        pageIndex < (cartItem.length / itemPerPage).ceil();
        pageIndex++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            final List<CartItem> currentPageItems = cartItem
                .skip(pageIndex * itemPerPage)
                .take(itemPerPage)
                .toList();
            return pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 1,
                ),
              ),
              padding: pw.EdgeInsets.all(10.scale),
              child: pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Spacer(),
                        pw.Text(
                          Strings.skfoods.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 28,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(width: 10.scale),
                        pw.Image(
                          companyLogo,
                          height: 80.scale,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 30.scale),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${Strings.date} ${Strings.colon} ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          date,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20.scale),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${Strings.billTo} ${Strings.colon}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16.scale,
                              ),
                            ),
                            pw.SizedBox(height: 5.scale),
                            pw.Text(
                              cname,
                            ),
                            pw.Text(
                              caddr1,
                            ),
                            pw.Text(
                              caddr2,
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${Strings.paymentInformation} ${Strings.colon}',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 16.scale,
                              ),
                            ),
                            pw.SizedBox(height: 5.scale),
                            pw.Row(
                              children: [
                                pw.Text(
                                  '${Strings.bankName} ${Strings.colon} ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  bank,
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text(
                                  '${Strings.accountName} ${Strings.colon} ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  accName,
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text(
                                  '${Strings.accountNo} ${Strings.colon} ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  accNo,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10.scale),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 1,
                      ),
                      children: [
                        rowHeader(),
                        for (int i = 0; i < currentPageItems.length; i++)
                          rowItems(
                            sno: pageIndex + i + 1,
                            date: cartItem[i].date ?? '',
                            item: cartItem[i].item ?? '',
                            qty: '${cartItem[i].qty}',
                            rate: cartItem[i].unit!.isEmpty
                                ? '${cartItem[i].unitPrice}'
                                : '${cartItem[i].unitPrice}/${cartItem[i].unit}',
                            amount:
                                '${cartItem[i].qty! * cartItem[i].unitPrice!}',
                          ),
                      ],
                    ),
                    if (pageIndex == (cartItem.length / itemPerPage).ceil() - 1)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.bottomRight,
                            margin: pw.EdgeInsets.only(
                                top: 20.scale, right: 5.scale),
                            padding: pw.EdgeInsets.all(10.scale),
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(10),
                              color: AppColors.darkBluePDF,
                            ),
                            child: pw.Text(
                              '${Strings.total.toUpperCase()} ${Strings.colon} Rs.${grandTotal.value}/-',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    final filePath = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      fileName: 'invoice - $todayDate.pdf',
    );

    if (filePath != null) {
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      cartItem.clear();
      grandTotal.value = 0;
      showSnackBar(
        title: Strings.success,
        message: '${Strings.pdfSavedAt} ${file.path}',
        contentType: ContentType.success,
      );
    } else {
      showSnackBar(
        title: Strings.failure,
        message: Strings.pdfSavingDenied,
        contentType: ContentType.failure,
      );
      return;
    }
  }

  Future<pw.MemoryImage> loadImage(String imagePath) async {
    final bytes = await rootBundle.load(imagePath);
    final imageData = bytes.buffer.asUint8List();
    return pw.MemoryImage(
      imageData,
    );
  }
}

pw.TableRow rowHeader() {
  return pw.TableRow(
    decoration: pw.BoxDecoration(
      color: AppColors.darkBluePDF,
    ),
    children: [
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          Strings.sno,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          Strings.date.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          Strings.item.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          Strings.qty.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          Strings.rate.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          Strings.amount.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
      ),
    ],
  );
}

pw.TableRow rowItems({
  required int sno,
  required String date,
  required String item,
  required String qty,
  required String rate,
  required String amount,
}) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          '$sno',
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          date,
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          item,
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          qty,
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          'Rs.$rate',
          textAlign: pw.TextAlign.center,
        ),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(5.scale),
        child: pw.Text(
          'Rs.$amount',
          textAlign: pw.TextAlign.center,
        ),
      ),
    ],
  );
}

class CartItem {
  String? date;
  String? item;
  String? unit;
  int? qty;
  int? unitPrice;
  int? totalPrice;
}
