import '../models/invoice_model.dart';
import '../models/invoice_item_model.dart';
import 'db_helper.dart';

class InvoiceDAO {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insertInvoice(
      InvoiceModel invoice, List<InvoiceItemModel> items) async {
    final db = await _dbHelper.db;
    return await db.transaction((txn) async {
      final invoiceId = await txn.insert('invoices', invoice.toMap());
      for (var item in items) {
        final itemMap = item.toMap();
        itemMap['invoice_id'] = invoiceId;
        await txn.insert('invoice_items', itemMap);
      }
      return invoiceId;
    });
  }

  Future<int> updateInvoiceStatus(
      int invoiceId, String status, double paidAmount) async {
    final db = await _dbHelper.db;
    return await db.update(
      'invoices',
      {'status': status, 'paid_amount': paidAmount},
      where: 'id = ?',
      whereArgs: [invoiceId],
    );
  }

  Future<int> deleteInvoice(int id) async {
    final db = await _dbHelper.db;
    return await db.transaction((txn) async {
      await txn.delete('invoice_items', where: 'invoice_id = ?', whereArgs: [id]);
      await txn.delete('payments', where: 'invoice_id = ?', whereArgs: [id]);
      return await txn.delete('invoices', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<InvoiceModel>> getAll() async {
    final db = await _dbHelper.db;
    final maps = await db.query('invoices', orderBy: 'id DESC');
    return maps.map((m) => InvoiceModel.fromMap(m)).toList();
  }

  Future<List<InvoiceItemModel>> getInvoiceItems(int invoiceId) async {
    final db = await _dbHelper.db;
    final maps = await db.query('invoice_items',
        where: 'invoice_id = ?', whereArgs: [invoiceId]);
    return maps.map((m) => InvoiceItemModel.fromMap(m)).toList();
  }

  Future<InvoiceModel?> getById(int id) async {
    final db = await _dbHelper.db;
    final maps = await db.query('invoices', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InvoiceModel.fromMap(maps.first);
    }
    return null;
  }
}
