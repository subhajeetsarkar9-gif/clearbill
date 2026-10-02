import 'package:flutter/material.dart';
import '../models/invoice_model.dart';
import '../models/invoice_item_model.dart';
import '../models/payment_model.dart';
import '../database/invoice_dao.dart';
import '../database/payment_dao.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceDAO _invoiceDAO = InvoiceDAO();
  final PaymentDAO _paymentDAO = PaymentDAO();

  List<InvoiceModel> _invoices = [];
  bool _isLoading = false;

  List<InvoiceModel> get invoices => _invoices;
  bool get isLoading => _isLoading;

  double get totalRevenue => _invoices.fold(0.0, (sum, inv) => sum + inv.paidAmount);
  double get totalPending => _invoices.fold(0.0, (sum, inv) => sum + inv.balanceAmount);

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();
    _invoices = await _invoiceDAO.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<int> createInvoice(
      InvoiceModel invoice, List<InvoiceItemModel> items) async {
    final id = await _invoiceDAO.insertInvoice(invoice, items);
    await loadInvoices();
    return id;
  }

  Future<void> deleteInvoice(int id) async {
    await _invoiceDAO.deleteInvoice(id);
    await loadInvoices();
  }

  Future<List<InvoiceItemModel>> getInvoiceItems(int invoiceId) async {
    return await _invoiceDAO.getInvoiceItems(invoiceId);
  }

  Future<List<PaymentModel>> getInvoicePayments(int invoiceId) async {
    return await _paymentDAO.getByInvoiceId(invoiceId);
  }

  Future<void> recordPayment(PaymentModel payment, InvoiceModel invoice) async {
    await _paymentDAO.insert(payment);
    final newPaid = invoice.paidAmount + payment.amountPaid;
    final newStatus = newPaid >= invoice.total ? 'PAID' : 'PARTIAL';
    await _invoiceDAO.updateInvoiceStatus(invoice.id!, newStatus, newPaid);
    await loadInvoices();
  }
}
