import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/invoice_model.dart';
import '../models/invoice_item_model.dart';
import '../models/client_model.dart';
import '../models/business_model.dart';
import '../utils/currency_formatter.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';

class PDFService {
  static Future<File> generateInvoicePDF({
    required InvoiceModel invoice,
    required List<InvoiceItemModel> items,
    required ClientModel client,
    required BusinessModel business,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        business.name.toUpperCase(),
                        style: const pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal,
                        ),
                      ),
                      if (business.gstin != null && business.gstin!.isNotEmpty)
                        pw.Text('GSTIN: ${business.gstin}'),
                      if (business.address != null) pw.Text(business.address!),
                      if (business.phone != null) pw.Text('Ph: ${business.phone}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'TAX INVOICE',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.Text('Invoice No: ${invoice.invoiceNumber}'),
                      pw.Text('Date: ${DateUtilsFormatter.formatDateIso(invoice.invoiceDate)}'),
                      pw.Text('Due Date: ${DateUtilsFormatter.formatDateIso(invoice.dueDate)}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('BILL TO:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(client.name, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      if (client.gstin != null && client.gstin!.isNotEmpty)
                        pw.Text('GSTIN: ${client.gstin}'),
                      if (client.billingAddress != null) pw.Text(client.billingAddress!),
                      if (client.phone != null) pw.Text('Ph: ${client.phone}'),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Status: ${invoice.status}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Type: ${invoice.isInterstate ? 'IGST (Interstate)' : 'CGST+SGST (Intrastate)'}'),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['#', 'Item & HSN', 'Qty', 'Rate', 'GST%', 'GST Amt', 'Total'],
                data: items.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final item = entry.value;
                  return [
                    '$idx',
                    '${item.productName}${item.hsnCode != null ? '\nHSN: ${item.hsnCode}' : ''}',
                    '${item.quantity}',
                    '₹${item.rate.toStringAsFixed(2)}',
                    '${item.gstPercent}%',
                    '₹${item.gstAmount.toStringAsFixed(2)}',
                    '₹${item.totalAmount.toStringAsFixed(2)}',
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
                cellAlignment: pw.Alignment.centerLeft,
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 6,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Amount in Words:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(CurrencyFormatter.numberToWords(invoice.total)),
                        pw.SizedBox(height: 10),
                        if (business.bankName != null && business.bankName!.isNotEmpty) ...[
                          pw.Text('Bank Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Bank: ${business.bankName} | A/C: ${business.accountNumber}'),
                          pw.Text('IFSC: ${business.ifscCode} | UPI: ${business.upiId ?? "N/A"}'),
                        ],
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        _pdfRow('Subtotal', '₹${invoice.subtotal.toStringAsFixed(2)}'),
                        if (!invoice.isInterstate) ...[
                          _pdfRow('CGST', '₹${invoice.cgst.toStringAsFixed(2)}'),
                          _pdfRow('SGST', '₹${invoice.sgst.toStringAsFixed(2)}'),
                        ] else ...[
                          _pdfRow('IGST', '₹${invoice.igst.toStringAsFixed(2)}'),
                        ],
                        pw.Divider(),
                        _pdfRow('Grand Total', '₹${invoice.total.toStringAsFixed(2)}', isBold: true),
                        _pdfRow('Paid Amount', '₹${invoice.paidAmount.toStringAsFixed(2)}'),
                        _pdfRow('Balance Due', '₹${invoice.balanceAmount.toStringAsFixed(2)}', isBold: true),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Terms: ${business.terms ?? "Thank you for your business!"}',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                  pw.Text('Authorised Signatory',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  AppConstants.pdfFooterText,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
              ),
            ],
          );
        },
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/Invoice_${invoice.invoiceNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _pdfRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(value, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}
