import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/invoice_model.dart';
import '../../models/invoice_item_model.dart';
import '../../models/client_model.dart';
import '../../models/product_model.dart';
import '../../providers/client_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/premium_provider.dart';
import '../../utils/constants.dart';
import '../../utils/gst_calculator.dart';
import '../../utils/invoice_number_generator.dart';
import '../../widgets/invoice/gst_summary_widget.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/limit_reached_dialog.dart';
import '../../theme/app_colors.dart';
import '../../database/db_helper.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  ClientModel? _selectedClient;
  bool _isInterstate = false;
  final List<InvoiceItemModel> _items = [];
  final _notesController = TextEditingController();
  final _invoiceNumController = TextEditingController();

  late DateTime _invDate;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _invDate = DateTime.now();
    _dueDate = DateTime.now().add(const Duration(days: 15));
    _generateInvoiceNumber();
  }

  Future<void> _generateInvoiceNumber() async {
    final b = Provider.of<BusinessProvider>(context, listen: false).business;
    final prefix = b?.invoicePrefix ?? 'CB';
    final db = await DBHelper().db;
    final generated = await InvoiceNumberGenerator.generate(db, prefix);
    setState(() {
      _invoiceNumController.text = generated;
    });
  }

  void _addItem() {
    final products = Provider.of<ProductProvider>(context, listen: false).products;
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one product first!')),
      );
      return;
    }

    ProductModel p = products.first;
    double qty = 1;
    double rate = p.price;
    double gst = p.gstPercent;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<ProductModel>(
              value: p,
              isExpanded: true,
              items: products
                  .map((prod) => DropdownMenuItem(value: prod, child: Text(prod.name)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  p = val;
                  rate = val.price;
                  gst = val.gstPercent;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              final calc = GSTCalculator.calculateItemGST(
                quantity: qty,
                rate: rate,
                gstPercent: gst,
              );
              setState(() {
                _items.add(InvoiceItemModel(
                  productName: p.name,
                  hsnCode: p.hsnCode,
                  quantity: qty,
                  rate: rate,
                  gstPercent: gst,
                  gstAmount: calc['gstAmount']!,
                  totalAmount: calc['totalAmount']!,
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<ClientProvider>(context).clients;
    final totals = GSTCalculator.calculateInvoiceTotals(
      items: _items,
      isInterState: _isInterstate,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Invoice - ${AppConstants.appName}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Consumer<PremiumProvider>(
              builder: (context, premium, _) {
                return TextFormField(
                  controller: _invoiceNumController,
                  decoration: InputDecoration(
                    labelText: 'Invoice Number *',
                    border: const OutlineInputBorder(),
                    suffixIcon: premium.canEditInvoiceNumber
                        ? null
                        : const Icon(Icons.lock_outline, color: Colors.amber),
                  ),
                  onTap: () {
                    if (!premium.canEditInvoiceNumber) {
                      FocusScope.of(context).unfocus();
                      LimitReachedDialog.showEditInvoiceLocked(context);
                    }
                  },
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Invoice number required';
                    final existingInvoices = Provider.of<InvoiceProvider>(context, listen: false).invoices;
                    final duplicate = existingInvoices.any((i) => i.invoiceNumber.toLowerCase() == v.trim().toLowerCase());
                    if (duplicate) return 'Invoice number already exists';
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ClientModel>(
              value: _selectedClient,
              decoration: const InputDecoration(labelText: 'Select Client *', border: OutlineInputBorder()),
              items: clients
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedClient = val;
                  if (val?.stateCode != null) {
                    final b = Provider.of<BusinessProvider>(context, listen: false).business;
                    _isInterstate = (val!.stateCode != b?.stateCode);
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Interstate Supply (IGST)'),
              value: _isInterstate,
              onChanged: (v) => setState(() => _isInterstate = v),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Items List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(onPressed: _addItem, icon: const Icon(Icons.add_circle, color: AppColors.primary)),
              ],
            ),
            if (_items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No items added yet')),
              )
            else
              ..._items.asMap().entries.map((entry) {
                final item = entry.value;
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text('${item.quantity} x ₹${item.rate} (${item.gstPercent}% GST)'),
                  trailing: Text('₹${item.totalAmount.toStringAsFixed(2)}'),
                );
              }),
            const SizedBox(height: 16),
            GSTSummaryWidget(
              subtotal: totals['subtotal']!,
              cgst: totals['cgst']!,
              sgst: totals['sgst']!,
              igst: totals['igst']!,
              total: totals['grandTotal']!,
              isInterstate: _isInterstate,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'GENERATE INVOICE',
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                if (_selectedClient == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a client')),
                  );
                  return;
                }
                if (_items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please add at least one item')),
                  );
                  return;
                }

                final premium = Provider.of<PremiumProvider>(context, listen: false);
                final invProvider = Provider.of<InvoiceProvider>(context, listen: false);

                final now = DateTime.now();
                final monthCount = invProvider.invoices.where((i) {
                  try {
                    final d = DateTime.parse(i.invoiceDate);
                    return d.year == now.year && d.month == now.month;
                  } catch (_) {
                    return false;
                  }
                }).length;

                if (!premium.canCreateInvoice(monthCount)) {
                  LimitReachedDialog.showInvoiceLimit(context);
                  return;
                }

                final inv = InvoiceModel(
                  invoiceNumber: _invoiceNumController.text.trim(),
                  clientID: _selectedClient!.id!,
                  invoiceDate: _invDate.toIso8601String(),
                  dueDate: _dueDate.toIso8601String(),
                  subtotal: totals['subtotal']!,
                  cgst: totals['cgst']!,
                  sgst: totals['sgst']!,
                  igst: totals['igst']!,
                  total: totals['grandTotal']!,
                  notes: _notesController.text,
                  isInterstate: _isInterstate,
                );

                await invProvider.createInvoice(inv, _items);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
