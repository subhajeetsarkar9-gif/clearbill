import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/business_model.dart';
import '../../providers/business_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/common/custom_button.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gstinController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _upiController = TextEditingController();
  final _prefixController = TextEditingController(text: 'INV');
  final _startNumController = TextEditingController(text: '1');

  String? _selectedStateCode = '27';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Business - ${AppConstants.appName}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Enter your business & GST details to start creating invoices.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Business Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              validator: (v) => Validators.validateRequired(v, 'Business Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gstinController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'GSTIN (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.verified_user),
              ),
              validator: Validators.validateGSTIN,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStateCode,
              decoration: const InputDecoration(
                labelText: 'State *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
              items: AppConstants.indianStates.map((state) {
                return DropdownMenuItem<String>(
                  value: state['code'],
                  child: Text('${state['code']} - ${state['name']}'),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedStateCode = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Business Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 20),
            const Text('Bank & Payment Info (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                labelText: 'Bank Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _accountController,
              decoration: const InputDecoration(
                labelText: 'Account Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ifscController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'IFSC Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _upiController,
              decoration: const InputDecoration(
                labelText: 'UPI ID (e.g. name@upi)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'SAVE & CONTINUE',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final business = BusinessModel(
                    name: _nameController.text.trim(),
                    gstin: _gstinController.text.trim(),
                    address: _addressController.text.trim(),
                    phone: _phoneController.text.trim(),
                    email: _emailController.text.trim(),
                    bankName: _bankNameController.text.trim(),
                    accountNumber: _accountController.text.trim(),
                    ifscCode: _ifscController.text.trim(),
                    upiId: _upiController.text.trim(),
                    invoicePrefix: _prefixController.text.trim(),
                    invoiceStartNumber: int.tryParse(_startNumController.text) ?? 1,
                    stateCode: _selectedStateCode,
                  );

                  final provider = Provider.of<BusinessProvider>(context, listen: false);
                  await provider.saveBusiness(business);
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
