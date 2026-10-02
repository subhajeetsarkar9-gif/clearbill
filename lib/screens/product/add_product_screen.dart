import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/premium_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/limit_reached_dialog.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _hsnController = TextEditingController();

  double _gstPercent = 18.0;
  final String _unit = 'pcs';
  final bool _isService = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product / Service'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name *', border: OutlineInputBorder()),
              validator: (v) => Validators.validateRequired(v, 'Item Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Selling Price (₹) *', border: OutlineInputBorder()),
              validator: (v) => Validators.validateRequired(v, 'Price'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<double>(
              value: _gstPercent,
              decoration: const InputDecoration(labelText: 'GST % Rate', border: OutlineInputBorder()),
              items: const [0, 5, 12, 18, 28]
                  .map((rate) => DropdownMenuItem(value: rate.toDouble(), child: Text('$rate%')))
                  .toList(),
              onChanged: (v) => setState(() => _gstPercent = v ?? 18.0),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hsnController,
              decoration: const InputDecoration(labelText: 'HSN / SAC Code', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'SAVE PRODUCT',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final premium = Provider.of<PremiumProvider>(context, listen: false);
                  final productProvider = Provider.of<ProductProvider>(context, listen: false);

                  if (!premium.canAddProduct(productProvider.products.length)) {
                    LimitReachedDialog.showProductLimit(context);
                    return;
                  }

                  final p = ProductModel(
                    name: _nameController.text.trim(),
                    price: double.tryParse(_priceController.text) ?? 0.0,
                    gstPercent: _gstPercent,
                    unit: _unit,
                    hsnCode: _hsnController.text.trim(),
                    isService: _isService,
                  );
                  await productProvider.addProduct(p);
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
