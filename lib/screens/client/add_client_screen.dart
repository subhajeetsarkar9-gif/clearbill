import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/client_model.dart';
import '../../providers/client_provider.dart';
import '../../providers/premium_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/limit_reached_dialog.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstinController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedStateCode = '27';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Client'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Client Name *', border: OutlineInputBorder()),
              validator: (v) => Validators.validateRequired(v, 'Client Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gstinController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'GSTIN', border: OutlineInputBorder()),
              validator: Validators.validateGSTIN,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStateCode,
              decoration: const InputDecoration(labelText: 'State', border: OutlineInputBorder()),
              items: AppConstants.indianStates
                  .map((s) => DropdownMenuItem(value: s['code'], child: Text('${s['code']} - ${s['name']}')))
                  .toList(),
              onChanged: (v) => setState(() => _selectedStateCode = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Billing Address', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'SAVE CLIENT',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final premium = Provider.of<PremiumProvider>(context, listen: false);
                  final clientProvider = Provider.of<ClientProvider>(context, listen: false);

                  if (!premium.canAddClient(clientProvider.clients.length)) {
                    LimitReachedDialog.showClientLimit(context);
                    return;
                  }

                  final client = ClientModel(
                    name: _nameController.text.trim(),
                    phone: _phoneController.text.trim(),
                    email: _emailController.text.trim(),
                    gstin: _gstinController.text.trim(),
                    billingAddress: _addressController.text.trim(),
                    stateCode: _selectedStateCode,
                  );
                  await clientProvider.addClient(client);
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
