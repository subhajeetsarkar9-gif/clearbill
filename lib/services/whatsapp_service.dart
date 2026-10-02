import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/invoice_model.dart';
import '../models/client_model.dart';
import '../utils/currency_formatter.dart';

class WhatsAppService {
  static Future<void> shareInvoicePDF(File pdfFile, InvoiceModel invoice, ClientModel client) async {
    final text = 'Hello ${client.name},\n\nPlease find attached invoice ${invoice.invoiceNumber} for ${CurrencyFormatter.format(invoice.total)}.\n\nThank you for choosing us!';
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      text: text,
    );
  }

  static Future<void> sendDirectWhatsAppMessage(String phoneNumber, String message) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse('https://wa.me/91$cleanPhone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
