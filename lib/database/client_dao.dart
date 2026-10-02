import '../models/client_model.dart';
import 'db_helper.dart';

class ClientDAO {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insert(ClientModel client) async {
    final db = await _dbHelper.db;
    return await db.insert('clients', client.toMap());
  }

  Future<int> update(ClientModel client) async {
    final db = await _dbHelper.db;
    return await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.db;
    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ClientModel>> getAll() async {
    final db = await _dbHelper.db;
    final maps = await db.query('clients', orderBy: 'name ASC');
    return maps.map((m) => ClientModel.fromMap(m)).toList();
  }

  Future<ClientModel?> getById(int id) async {
    final db = await _dbHelper.db;
    final maps = await db.query('clients', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ClientModel.fromMap(maps.first);
    }
    return null;
  }
}
