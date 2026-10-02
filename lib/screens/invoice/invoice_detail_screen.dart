import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client_model.dart';
import '../../models/payment_model.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/premium_provider.dart';
import '../../services/pdf_service.dart';
import '../../services/whatsapp_service.dart';
import '../../utils/currency_formatter.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/limit_reached_dialog.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final int invoiceId;
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final invProvider = Provider.of<InvoiceProvider>(context);
    final invoice = invProvider.invoices.firstWhere((i) => i.id == widget.invoiceId);
    final client = Provider.of<ClientProvider>(context).clients.firstWhere(
          (c) => c.id == invoice.clientID,
          orElse: () => ClientModel(name: 'Client'),
        );
    final business = Provider.of<BusinessProvider>(context).business;

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${invoice.invoiceNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await invProvider.deleteInvoice(invoice.id!);
              if (mounted) Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice Number: ${invoice.invoiceNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Client: ${client.name}'),
                  Text('Total Amount: ${CurrencyFormatter.format(invoice.total)}'),
                  Text('Paid Amount: ${CurrencyFormatter.format(invoice.paidAmount)}'),
                  Text('Status: ${invoice.status}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (business == null) return;
                    final items = await invProvider.getInvoiceItems(invoice.id!);
                    final file = await PDFService.generateInvoicePDF(
                      invoice: invoice,
                      items: items,
                      client: client,
                      business: business,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('PDF saved: ${file.path}')),
                      );
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Download PDF'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final premium = Provider.of<PremiumProvider>(context, listen: false);
                    if (!premium.canShareWhatsApp) {
                      LimitReachedDialog.showWhatsAppLocked(context);
                      return;
                    }
                    if (business == null) return;
                    final items = await invProvider.getInvoiceItems(invoice.id!);
                    final file = await PDFService.generateInvoicePDF(
                      invoice: invoice,
                      items: items,
                      client: client,
                      business: business,
                    );
                    await WhatsAppService.shareInvoicePDF(file, invoice, client);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share WhatsApp'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (invoice.balanceAmount > 0)
            ElevatedButton.icon(
              onPressed: () {
                final amtController = TextEditingController(text: invoice.balanceAmount.toString());
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Record Payment'),
                    content: TextField(
                      controller: amtController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount Paid (₹)'),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
                      ElevatedButton(
                        onPressed: () async {
                          final amt = double.tryParse(amtController.text) ?? 0.0;
                          if (amt > 0) {
                            final payment = PaymentModel(
                              invoiceID: invoice.id!,
                              amountPaid: amt,
                              paymentDate: DateTime.now().toIso8601String(),
                              paymentMethod: 'Cash',
                            );
                            await invProvider.recordPayment(payment, invoice);
                          }
                          Navigator.pop(ctx);
                        },
                        child: const Text('RECORD'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('RECORD PAYMENT'),
            ),
        ],
      ),
    );
  }
}
