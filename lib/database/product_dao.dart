import '../models/product_model.dart';
import 'db_helper.dart';

class ProductDAO {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insert(ProductModel product) async {
    final db = await _dbHelper.db;
    return await db.insert('products', product.toMap());
  }

  Future<int> update(ProductModel product) async {
    final db = await _dbHelper.db;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.db;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ProductModel>> getAll() async {
    final db = await _dbHelper.db;
    final maps = await db.query('products', orderBy: 'name ASC');
    return maps.map((m) => ProductModel.fromMap(m)).toList();
  }
}
