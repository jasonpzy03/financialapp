final String tableAccounts = "accounts";

class AccountFields {
  static final List<String> values = [
    /// Add all fields
    id, accountGroup, name, amount, description
  ];

  static final String id = '_id';
  static final String accountGroup = 'accountGroup';
  static final String name = 'name';
  static final String amount = 'amount';
  static final String description = 'description';
}

class AccountData {
  final int? id;
  final String accountGroup;
  final String name;
  final double amount;
  final String description;

  const AccountData({
    this.id,
    required this.accountGroup,
    required this.name,
    required this.amount,
    required this.description
  });

  AccountData copy({
    int? id,
    String? accountGroup,
    String? name,
    double? amount,
    String? description,
  }) =>
      AccountData(
          id: id ?? this.id,
          accountGroup: accountGroup ?? this.accountGroup,
          name: name ?? this.name,
          amount: amount ?? this.amount,
          description: description ?? this.description,
      );

  static AccountData fromJson(Map<String, Object?> json) => AccountData(
      id: json[AccountFields.id] as int?,
      accountGroup: json[AccountFields.accountGroup] as String,
      name: json[AccountFields.name] as String,
      amount: json[AccountFields.amount] as double,
      description: json[AccountFields.description] as String,
  );

  Map<String, Object?> toJson() => {
    AccountFields.id: id,
    AccountFields.accountGroup: accountGroup,
    AccountFields.name: name,
    AccountFields.amount: amount.toString(),
    AccountFields.description: description,
  };
}