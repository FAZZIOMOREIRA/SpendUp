import 'dart:convert';

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String passwordHash;
  final int? age;
  final String employmentStatus;
  final double monthlyIncome;
  final double monthlyExpenses;
  final String mainGoal;
  final String financialLevel;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passwordHash,
    this.age,
    this.employmentStatus = 'autre',
    required this.monthlyIncome,
    required this.monthlyExpenses,
    this.mainGoal = 'budget',
    this.financialLevel = 'débutant',
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'passwordHash': passwordHash,
        'age': age,
        'employmentStatus': employmentStatus,
        'monthlyIncome': monthlyIncome,
        'monthlyExpenses': monthlyExpenses,
        'mainGoal': mainGoal,
        'financialLevel': financialLevel,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] ?? '',
        firstName: map['firstName'] ?? '',
        lastName: map['lastName'] ?? '',
        email: map['email'] ?? '',
        passwordHash: map['passwordHash'] ?? '',
        age: map['age'] as int?,
        employmentStatus: map['employmentStatus'] ?? 'autre',
        monthlyIncome: (map['monthlyIncome'] as num?)?.toDouble() ?? 0,
        monthlyExpenses: (map['monthlyExpenses'] as num?)?.toDouble() ?? 0,
        mainGoal: map['mainGoal'] ?? 'budget',
        financialLevel: map['financialLevel'] ?? 'débutant',
        createdAt: map['createdAt'] != null
            ? DateTime.parse(map['createdAt'])
            : DateTime.now(),
      );

  String toJson() => json.encode(toMap());
  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    int? age,
    String? employmentStatus,
    double? monthlyIncome,
    double? monthlyExpenses,
    String? mainGoal,
    String? financialLevel,
  }) {
    return UserProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      passwordHash: passwordHash,
      age: age ?? this.age,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      mainGoal: mainGoal ?? this.mainGoal,
      financialLevel: financialLevel ?? this.financialLevel,
      createdAt: createdAt,
    );
  }
}

const List<Map<String, String>> kEmploymentStatuses = [
  {'id': 'salarié', 'label': 'Salarié(e)', 'icon': '💼'},
  {'id': 'entrepreneur', 'label': 'Entrepreneur(e)', 'icon': '🚀'},
  {'id': 'étudiant', 'label': 'Étudiant(e)', 'icon': '🎓'},
  {'id': 'freelance', 'label': 'Freelance', 'icon': '💻'},
  {'id': 'autre', 'label': 'Autre', 'icon': '👤'},
];

const List<Map<String, String>> kMainGoals = [
  {'id': 'épargner', 'label': 'Épargner régulièrement', 'icon': '💰'},
  {'id': 'dettes', 'label': 'Rembourser mes dettes', 'icon': '📉'},
  {'id': 'investir', 'label': 'Commencer à investir', 'icon': '📈'},
  {'id': 'budget', 'label': 'Mieux gérer mon budget', 'icon': '📊'},
  {'id': 'urgence', 'label': 'Constituer un fonds d\'urgence', 'icon': '🛡️'},
];

const List<Map<String, String>> kFinancialLevels = [
  {
    'id': 'débutant',
    'label': 'Débutant',
    'desc': 'Je découvre la gestion financière',
    'icon': '🌱',
  },
  {
    'id': 'intermédiaire',
    'label': 'Intermédiaire',
    'desc': 'Je connais les bases du budget',
    'icon': '🌿',
  },
  {
    'id': 'avancé',
    'label': 'Avancé',
    'desc': 'J\'investis et j\'optimise mes finances',
    'icon': '🌳',
  },
];
