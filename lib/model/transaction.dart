final String tableTransactions = "transactions";

class TransactionFields {
  static final List<String> values = [
    /// Add all fields
    id, date, account, category, amount, note, transactType
  ];

  static final String id = '_id';
  static final String date = 'date';
  static final String account = 'account';
  static final String category = 'category';
  static final String amount = 'amount';
  static final String note = 'note';
  static final String transactType = 'transactType';
}

class TransactionData {
  final int? id;
  final DateTime date;
  final String account;
  final String category;
  final double amount;
  final String note;
  final String transactType;

  const TransactionData({
    this.id,
    required this.date,
    required this.account,
    required this.category,
    required this.amount,
    required this.note,
    required this.transactType
  });

  TransactionData copy({
    int? id,
    DateTime? date,
    String? account,
    String? category,
    double? amount,
    String? note,
    String? transactType
  }) =>
      TransactionData(
        id: id ?? this.id,
        date: date ?? this.date,
        account: account ?? this.account,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        note: note ?? this.note,
        transactType: transactType ?? this.transactType
      );

  static TransactionData fromJson(Map<String, Object?> json) => TransactionData(
    id: json[TransactionFields.id] as int?,
    date: DateTime.parse(json[TransactionFields.date] as String),
    account: json[TransactionFields.account] as String,
    category: json[TransactionFields.category] as String,
    amount: json[TransactionFields.amount] as double,
    note: json[TransactionFields.note] as String,
    transactType: json[TransactionFields.transactType] as String
  );

  Map<String, Object?> toJson() => {
    TransactionFields.id: id,
    TransactionFields.date: date.toIso8601String(),
    TransactionFields.account: account,
    TransactionFields.category: category,
    TransactionFields.amount: amount.toString(),
    TransactionFields.note: note,
    TransactionFields.transactType: transactType,
  };
}