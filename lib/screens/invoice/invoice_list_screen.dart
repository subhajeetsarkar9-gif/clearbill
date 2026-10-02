import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client_model.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/client_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/invoice/invoice_card.dart';
import '../../widgets/common/empty_state_widget.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invProvider = Provider.of<InvoiceProvider>(context);
    final clients = Provider.of<ClientProvider>(context).clients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Invoices'),
      ),
      body: invProvider.invoices.isEmpty
          ? EmptyStateWidget.noInvoices(
              onButtonPressed: () => Navigator.pushNamed(context, AppRoutes.createInvoice),
            )
          : ListView.builder(
              itemCount: invProvider.invoices.length,
              itemBuilder: (context, index) {
                final inv = invProvider.invoices[index];
                final client = clients.firstWhere(
                  (c) => c.id == inv.clientID,
                  orElse: () => ClientModel(name: 'Unknown Client'),
                );
                return InvoiceCard(
                  invoice: inv,
                  clientName: client.name,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.invoiceDetail,
                    arguments: inv.id,
                  ),
                );
              },
            ),
    );
  }
}
