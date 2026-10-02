import 'package:sqflite/sqflite.dart';
import '../models/business_model.dart';
import 'db_helper.dart';

class BusinessDAO {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insertOrUpdate(BusinessModel business) async {
    final db = await _dbHelper.db;
    final Map<String, dynamic> data = business.toMap();
    data['id'] = 1;
    return await db.insert(
      'business',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<BusinessModel?> getBusiness() async {
    final db = await _dbHelper.db;
    final maps = await db.query('business', where: 'id = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return BusinessModel.fromMap(maps.first);
    }
    return null;
  }
}
