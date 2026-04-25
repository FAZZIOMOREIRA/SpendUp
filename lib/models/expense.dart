import 'dart:convert';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String note;
  final bool isIncome;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note = '',
    this.isIncome = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'categoryId': categoryId,
        'date': date.toIso8601String(),
        'note': note,
        'isIncome': isIncome,
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        amount: (map['amount'] as num).toDouble(),
        categoryId: map['categoryId'] ?? 'other',
        date: DateTime.parse(map['date']),
        note: map['note'] ?? '',
        isIncome: map['isIncome'] as bool? ?? false,
      );

  String toJson() => json.encode(toMap());
  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source));

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? note,
    bool? isIncome,
  }) =>
      Expense(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        note: note ?? this.note,
        isIncome: isIncome ?? this.isIncome,
      );
}
