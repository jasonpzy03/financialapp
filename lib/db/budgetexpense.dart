import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/transaction.dart';

class BudgetExpenseDatabase {
  static final BudgetExpenseDatabase instance = BudgetExpenseDatabase._init();

  static Database? _database;

  BudgetExpenseDatabase._init();

  Future<Database> get database async {
    //databaseFactory.deleteDatabase(join(await getDatabasesPath(), 'budgetexpense.db'));
    if (_database != null) return _database!;

    _database = await _initDB('budgetexpense.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    print("creating db");
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateType = 'DATE NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
      CREATE TABLE $tableTransactions ( 
        ${TransactionFields.id} $idType, 
        ${TransactionFields.date} $dateType,
        ${TransactionFields.account} $textType,
        ${TransactionFields.category} $textType,
        ${TransactionFields.amount} $doubleType,
        ${TransactionFields.note} $textType,
        ${TransactionFields.transactType} $textType
        )
''');
  }

  Future<TransactionData> create(TransactionData transactionData) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTransactions, transactionData.toJson());
    return transactionData.copy(id: id);
  }

  Future<TransactionData> readTransaction(int month) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTransactions,
      columns: TransactionFields.values,
      where: 'MONTH(${TransactionFields.date}) = ?',
      whereArgs: [month],
    );

    if (maps.isNotEmpty) {
      return TransactionData.fromJson(maps.first);
    } else {
      throw Exception('ID $TransactionData not found');
    }
  }

  Future<List<TransactionData>> readAllTransactions(String month, String year) async {
    final db = await instance.database;

    if (month.length == 1) {
      month = "0" + month;
    }

    final orderBy = '${TransactionFields.date} DESC';

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableTransactions, orderBy: orderBy, where: "strftime('%m', ${TransactionFields.date}) = ? AND strftime('%Y', ${TransactionFields.date}) = ?", whereArgs:[month, year]);

    return result.map((json) => TransactionData.fromJson(json)).toList();
  }

  Future getInflow(String month, String year) async {
    final db = await instance.database;

    if (month.length == 1) {
      month = "0" + month;
    }

    final result =
        await db.rawQuery("SELECT SUM(${TransactionFields.amount}) as Inflow FROM $tableTransactions WHERE ${TransactionFields.transactType} = 'Income' AND strftime('%m', ${TransactionFields.date}) = '$month' AND strftime('%Y', ${TransactionFields.date}) = '$year'");

    return result.toList();
  }

  Future getOutflow(String month, String year) async {
    final db = await instance.database;

    if (month.length == 1) {
      month = "0" + month;
    }

    final result =
    await db.rawQuery("SELECT SUM(${TransactionFields.amount}) as Outflow FROM $tableTransactions WHERE ${TransactionFields.transactType} = 'Expense' AND strftime('%m', ${TransactionFields.date}) = '$month' AND strftime('%Y', ${TransactionFields.date}) = '$year'");

    return result.toList();
  }

  Future<int> update(TransactionData transactionData) async {
    final db = await instance.database;

    return db.update(
      tableTransactions,
      transactionData.toJson(),
      where: '${TransactionFields.id} = ?',
      whereArgs: [transactionData.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactions,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
