import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'clear_bill.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE business(
        id INTEGER PRIMARY KEY,
        name TEXT,
        gstin TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        logo_path TEXT,
        bank_name TEXT,
        account_number TEXT,
        ifsc_code TEXT,
        upi_id TEXT,
        terms TEXT,
        invoice_prefix TEXT,
        invoice_start_number INTEGER,
        state_code TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE clients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        gstin TEXT,
        billing_address TEXT,
        city TEXT,
        state TEXT,
        state_code TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        gst_percent REAL NOT NULL,
        unit TEXT,
        hsn_code TEXT,
        is_service INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice_number TEXT UNIQUE NOT NULL,
        client_id INTEGER,
        invoice_date TEXT,
        due_date TEXT,
        subtotal REAL,
        cgst REAL,
        sgst REAL,
        igst REAL,
        total REAL,
        paid_amount REAL DEFAULT 0,
        status TEXT DEFAULT 'UNPAID',
        notes TEXT,
        is_interstate INTEGER DEFAULT 0,
        created_at TEXT,
        FOREIGN KEY(client_id) REFERENCES clients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE invoice_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice_id INTEGER,
        product_name TEXT,
        hsn_code TEXT,
        quantity REAL,
        rate REAL,
        gst_percent REAL,
        gst_amount REAL,
        total_amount REAL,
        FOREIGN KEY(invoice_id) REFERENCES invoices(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice_id INTEGER,
        amount_paid REAL,
        payment_date TEXT,
        payment_method TEXT,
        note TEXT,
        created_at TEXT,
        FOREIGN KEY(invoice_id) REFERENCES invoices(id)
      )
    ''');
  }
}
