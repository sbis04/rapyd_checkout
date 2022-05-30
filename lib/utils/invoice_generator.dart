import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rapyd/models/models.dart';

Future<Uint8List> generateInvoice({
  required String invoiceNumber,
  required double taxFraction,
  required List<Product> products,
  required PaymentData paymentData,
}) async {
  final invoice = Invoice(
    invoiceNumber: invoiceNumber,
    products: products,
    customerName: paymentData.paymentMethodData.name,
    customerAddress:
        '${paymentData.paymentMethodData.address.line1} ${paymentData.paymentMethodData.address.line2 ?? ''}\n${paymentData.paymentMethodData.address.city} - ${paymentData.paymentMethodData.address.zip}\n${paymentData.paymentMethodData.address.state}, ${paymentData.paymentMethodData.address.country}',
    paymentInfo:
        '**** **** **** ${paymentData.paymentMethodData.last4}\n${paymentData.paymentMethodData.name}\n${paymentData.paymentMethodData.address.phoneNumber ?? ''}',
    tax: .12,
    baseColor: PdfColors.black,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf();
}

class Invoice {
  Invoice({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  pw.MemoryImage? _logo;

  // String? _bgShape;

  Future<Uint8List> buildPdf() async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = pw.MemoryImage(
      (await rootBundle.load('assets/slibro_rapyd_pay.png'))
          .buffer
          .asUint8List(),
    );
    // _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.a4,
          await PdfGoogleFonts.poppinsRegular(),
          await PdfGoogleFonts.poppinsBold(),
          await PdfGoogleFonts.poppinsItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(bottom: 16),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                      left: 16,
                      top: 10,
                      bottom: 10,
                      right: 16,
                    ),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice'),
                          pw.Text(invoiceNumber),
                          pw.Text('Date:'),
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 120,
                    child: pw.Image(_logo!),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        // pw.Container(
        //   height: 20,
        //   width: 100,
        //   child: pw.BarcodeWidget(
        //     barcode: pw.Barcode.pdf417(),
        //     data: 'Invoice# $invoiceNumber',
        //     drawText: false,
        //   ),
        // ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      // buildBackground: (context) => pw.FullPage(
      //   ignoreMargins: true,
      //   child: pw.SvgImage(svg: _bgShape!),
      // ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 16),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Container(
              margin: const pw.EdgeInsets.only(right: 40),
              height: 70,
              child: pw.FittedBox(
                child: pw.Text(
                  'Total: ${_formatCurrency(_grandTotal)}',
                  style: pw.TextStyle(
                    color: baseColor,
                  ),
                ),
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Row(
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 10, right: 10),
                  height: 70,
                  child: pw.Text(
                    'Invoice to:',
                    style: pw.TextStyle(
                      color: _darkColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    height: 70,
                    child: pw.RichText(
                      text: pw.TextSpan(
                        text: '$customerName\n',
                        style: pw.TextStyle(
                          color: _darkColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          const pw.TextSpan(
                            text: '\n',
                            style: pw.TextStyle(
                              fontSize: 5,
                            ),
                          ),
                          pw.TextSpan(
                            text: customerAddress,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for the purchase',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                paymentInfo,
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(_total)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                'This is a sample payment invoice for your purchase from the Slibro app. It uses the Rapyd payment gateway to process your payments, currently only using the sandbox mode.',
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ['Item Description', 'Price', 'Quantity', 'Total'];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

class Product {
  const Product(
    this.productName,
    this.price,
    this.quantity,
  );

  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return productName;
      case 1:
        return _formatCurrency(price);
      case 2:
        return quantity.toString();
      case 3:
        return _formatCurrency(total);
    }
    return '';
  }
}
