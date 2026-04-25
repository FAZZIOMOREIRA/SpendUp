import 'dart:convert';

class Budget {
  final double monthlyLimit;
  final double monthlyIncome;

  Budget({
    required this.monthlyLimit,
    required this.monthlyIncome,
  });

  Map<String, dynamic> toMap() {
    return {
      'monthlyLimit': monthlyLimit,
      'monthlyIncome': monthlyIncome,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      monthlyLimit: (map['monthlyLimit'] as num).toDouble(),
      monthlyIncome: (map['monthlyIncome'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source));

  Budget copyWith({double? monthlyLimit, double? monthlyIncome}) {
    return Budget(
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    );
  }
}
