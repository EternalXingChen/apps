import 'category_model.dart' show AccountType;

enum TransactionType {
  expense,
  income,
}

class TransactionModel {
  final String id;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final AccountType accountType;
  final DateTime timestamp;
  final String? note;
  final List<String>? tags;
  final bool isEncrypted;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get category => categoryId;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.accountType,
    required this.timestamp,
    this.note,
    this.tags,
    this.isEncrypted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'accountType': accountType.name,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'tags': tags?.join(','),
      'isEncrypted': isEncrypted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      type: TransactionType.values.byName(json['type']),
      categoryId: json['categoryId'],
      accountType: AccountType.values.byName(json['accountType'] ?? 'cash'),
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
      tags: json['tags']?.toString().split(',').where((s) => s.isNotEmpty).toList(),
      isEncrypted: json['isEncrypted'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? categoryId,
    AccountType? accountType,
    DateTime? timestamp,
    String? note,
    List<String>? tags,
    bool? isEncrypted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountType: accountType ?? this.accountType,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
