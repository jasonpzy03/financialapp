import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ui_practice_1/accountsBox.dart';
import '../model/account.dart';
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

    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateType = 'DATE NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
      CREATE TABLE $tableTransactions ( 
        ${TransactionFields.id} $idType, 
        ${TransactionFields.date} $dateType,
        ${TransactionFields.accountId} 'INTEGER NOT NULL', 
        ${TransactionFields.toAccountId} 'INTEGER NOT NULL', 
        ${TransactionFields.account} $textType,
        ${TransactionFields.category} $textType,
        ${TransactionFields.amount} $doubleType,
        ${TransactionFields.note} $textType,
        ${TransactionFields.transactType} $textType
        )
''');

    await db.execute('''
      CREATE TABLE $tableAccounts ( 
        ${AccountFields.id} $idType, 
        ${AccountFields.accountGroup} $textType,
        ${AccountFields.name} $textType,
        ${AccountFields.amount} $doubleType,
        ${AccountFields.description} $textType
        )
''');
  }

  Future<TransactionData> createTransaction(TransactionData transactionData) async {
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

  Future<AccountData> createAccount(AccountData accountData) async {
    final db = await instance.database;

    final id = await db.insert(tableAccounts, accountData.toJson());
    return accountData.copy(id: id);
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

  Future<List<AccountData>> readAllAccounts() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableAccounts, orderBy: "${AccountFields.id} ASC");//, where: "${AccountFields.accountGroup} = ?", whereArgs:[group]);

    return result.map((json) => AccountData.fromJson(json)).toList();
  }

  Future<Map<int?, AccountData>> readAllAccountsMap() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    //final result = await db.query(tableAccounts, orderBy: "${AccountFields.id} ASC");//, where: "${AccountFields.accountGroup} = ?", whereArgs:[group]);

    //return result.map((json) => AccountData.fromJson(json)).toList();

    final List<Map<String, dynamic>> result = await db.query(tableAccounts, orderBy: "${AccountFields.id} ASC");

    // Convert the List<Map<String, dynamic>> to a Map<int, AccountData>
    Map<int?, AccountData> accountMap = {};
    result.forEach((json) {
      AccountData accountData = AccountData.fromJson(json);
      accountMap[accountData.id] = accountData;
    });

    return accountMap;
  }

  Future readAvailableGroups() async {
    final db = await instance.database;

    final result =
    await db.rawQuery("SELECT DISTINCT ${AccountFields.accountGroup} FROM $tableAccounts");

    return result.map((row) => row['accountGroup'].toString()).toList();
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

  Future getAssets() async {
    final db = await instance.database;

    final result =
    await db.rawQuery("SELECT SUM(${AccountFields.amount}) as Assets FROM $tableAccounts WHERE ${AccountFields.amount} >= 0");

    return result.toList();
  }

  Future getLiabilities() async {
    final db = await instance.database;

    final result =
    await db.rawQuery("SELECT SUM(${AccountFields.amount}) as Liabilities FROM $tableAccounts WHERE ${AccountFields.amount} < 0");
    return result.toList();
  }

  Future getExpense(String category, String month, String year) async {
    final db = await instance.database;

    if (month.length == 1) {
      month = "0" + month;
    }

    final result =
    await db.rawQuery("SELECT SUM(${TransactionFields.amount}) as totalExpense FROM $tableTransactions WHERE ${TransactionFields.category} == '$category' AND strftime('%m', ${TransactionFields.date}) = '$month' AND strftime('%Y', ${TransactionFields.date}) = '$year'");
    return result.toList();
  }

  Future<int> updateTransaction(TransactionData transactionData) async {
    final db = await instance.database;

    return db.update(
      tableTransactions,
      transactionData.toJson(),
      where: '${TransactionFields.id} = ?',
      whereArgs: [transactionData.id],
    );
  }

  Future<int> updateAccountAmount(int? id, double amount, bool isAdding) async {
    final db = await instance.database;

    if (isAdding) {
      return db.rawUpdate("UPDATE $tableAccounts SET ${AccountFields.amount} = ${AccountFields.amount} + $amount WHERE ${AccountFields.id} = $id");
    } else {
      return db.rawUpdate("UPDATE $tableAccounts SET ${AccountFields.amount} = $amount WHERE ${AccountFields.id} = $id");

    }
  }

  Future<int> updateAccount(AccountData accountData) async {
    final db = await instance.database;

    return db.update(
      tableAccounts,
      accountData.toJson(),
      where: '${AccountFields.id} = ?',
      whereArgs: [accountData.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactions,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableAccounts,
      where: '${AccountFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
