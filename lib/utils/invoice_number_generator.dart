import 'package:sqflite/sqflite.dart';

class InvoiceNumberGenerator {
  static Future<String> generate(Database db, String prefix) async {
    final year = DateTime.now().year;
    final prefixYearPattern = '$prefix-$year-%';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT invoice_number FROM invoices WHERE invoice_number LIKE ? ORDER BY id DESC LIMIT 1",
      [prefixYearPattern],
    );

    int nextNumber = 1;
    if (maps.isNotEmpty) {
      final lastNumStr = maps.first['invoice_number'] as String?;
      if (lastNumStr != null) {
        final parts = lastNumStr.split('-');
        if (parts.length >= 3) {
          final parsed = int.tryParse(parts.last);
          if (parsed != null) {
            nextNumber = parsed + 1;
          }
        }
      }
    }

    return format(prefix, year, nextNumber);
  }

  static String format(String prefix, int year, int number) {
    final String formattedNum = number.toString().padLeft(3, '0');
    return '$prefix-$year-$formattedNum';
  }
}
