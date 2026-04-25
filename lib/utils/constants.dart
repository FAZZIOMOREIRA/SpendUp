import 'package:flutter/material.dart';

const String kCurrency = 'FCFA';
const String kAppName = 'SpendUp';

class CategoryData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

const List<CategoryData> kCategories = [
  CategoryData(
    id: 'food',
    name: 'Alimentation',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFFF9500),
  ),
  CategoryData(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car_rounded,
    color: Color(0xFF007AFF),
  ),
  CategoryData(
    id: 'bills',
    name: 'Factures',
    icon: Icons.receipt_long_rounded,
    color: Color(0xFFFF3B30),
  ),
  CategoryData(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag_rounded,
    color: Color(0xFFAF52DE),
  ),
  CategoryData(
    id: 'health',
    name: 'Santé',
    icon: Icons.favorite_rounded,
    color: Color(0xFF34C759),
  ),
  CategoryData(
    id: 'entertainment',
    name: 'Loisirs',
    icon: Icons.movie_rounded,
    color: Color(0xFFFF2D55),
  ),
  CategoryData(
    id: 'other',
    name: 'Autre',
    icon: Icons.category_rounded,
    color: Color(0xFF8E8E93),
  ),
];

CategoryData getCategoryById(String id) {
  return kCategories.firstWhere(
    (c) => c.id == id,
    orElse: () => kCategories.last,
  );
}

const List<Map<String, String>> kFinancialTips = [
  {
    'title': 'La règle 50/30/20',
    'description':
        'Allouez 50% de vos revenus aux besoins essentiels, 30% à vos envies et 20% à l\'épargne. Cette règle simple vous aide à maintenir un équilibre financier sain.',
    'icon': '💡',
    'category': 'Budget',
  },
  {
    'title': 'Constituez un fonds d\'urgence',
    'description':
        'Mettez de côté l\'équivalent de 3 à 6 mois de dépenses. Ce coussin financier vous protège contre les imprévus sans avoir à contracter des dettes.',
    'icon': '🛡️',
    'category': 'Épargne',
  },
  {
    'title': 'Automatisez votre épargne',
    'description':
        'Programmez un virement automatique vers votre compte épargne dès que vous recevez votre salaire. Épargnez en premier, dépensez le reste.',
    'icon': '🤖',
    'category': 'Épargne',
  },
  {
    'title': 'Évitez les achats impulsifs',
    'description':
        'Avant tout achat non planifié, attendez 24 heures. Cette pause vous permet de distinguer un vrai besoin d\'une envie passagère.',
    'icon': '⏳',
    'category': 'Dépenses',
  },
  {
    'title': 'Suivez vos dépenses quotidiennement',
    'description':
        'Notez chaque dépense, même petite. Les petits montants s\'accumulent rapidement et peuvent représenter une part importante de votre budget.',
    'icon': '📊',
    'category': 'Budget',
  },
  {
    'title': 'Négociez vos factures',
    'description':
        'N\'hésitez pas à négocier vos abonnements, assurances et factures. Une simple demande peut vous faire économiser des milliers de FCFA par an.',
    'icon': '🤝',
    'category': 'Économies',
  },
  {
    'title': 'Diversifiez vos sources de revenus',
    'description':
        'Cherchez des opportunités de revenus supplémentaires : freelance, vente de produits, location. Ne dépendez pas d\'une seule source de revenus.',
    'icon': '💰',
    'category': 'Revenus',
  },
  {
    'title': 'Investissez dans votre formation',
    'description':
        'Consacrer une partie de votre budget à l\'apprentissage de nouvelles compétences est l\'investissement avec le meilleur retour sur le long terme.',
    'icon': '📚',
    'category': 'Investissement',
  },
  {
    'title': 'Comparez avant d\'acheter',
    'description':
        'Prenez le temps de comparer les prix et les offres avant tout achat important. Les applications de comparaison peuvent vous faire économiser beaucoup.',
    'icon': '🔍',
    'category': 'Dépenses',
  },
  {
    'title': 'Planifiez vos achats alimentaires',
    'description':
        'Faites une liste de courses et respectez-la. Les achats alimentaires planifiés permettent d\'éviter le gaspillage et de réduire votre budget nourriture.',
    'icon': '🛒',
    'category': 'Budget',
  },
  {
    'title': 'Définissez des objectifs clairs',
    'description':
        'Des objectifs financiers précis (montant + délai) vous motivent et vous donnent une direction. Un objectif flou mène rarement à des résultats.',
    'icon': '🎯',
    'category': 'Objectifs',
  },
  {
    'title': 'Révisez votre budget mensuellement',
    'description':
        'Analysez vos dépenses chaque fin de mois. Identifiez les catégories où vous avez dépassé et ajustez votre comportement le mois suivant.',
    'icon': '📅',
    'category': 'Budget',
  },
];

const Map<String, Color> kCategoryTipColors = {
  'Budget': Color(0xFF5B4FFF),
  'Épargne': Color(0xFF00CF8D),
  'Dépenses': Color(0xFFFF8C42),
  'Économies': Color(0xFF00C6AE),
  'Revenus': Color(0xFFFFD60A),
  'Investissement': Color(0xFFAF52DE),
  'Objectifs': Color(0xFFFF3B5C),
};
