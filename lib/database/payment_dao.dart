import '../models/payment_model.dart';
import 'db_helper.dart';

class PaymentDAO {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insert(PaymentModel payment) async {
    final db = await _dbHelper.db;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<PaymentModel>> getByInvoiceId(int invoiceId) async {
    final db = await _dbHelper.db;
    final maps = await db.query('payments',
        where: 'invoice_id = ?', whereArgs: [invoiceId], orderBy: 'id DESC');
    return maps.map((m) => PaymentModel.fromMap(m)).toList();
  }
}
