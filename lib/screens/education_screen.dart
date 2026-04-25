import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Éducation Financière',
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Apprenez à maîtriser vos finances',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF221E3A)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF5B4FFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade500,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Conseils'),
                  Tab(text: 'Quiz'),
                  Tab(text: 'Glossaire'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _TipsTab(),
                  _QuizTab(),
                  _GlossaryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Données ───────────────────────────────────────────────────────────────────

const List<Map<String, String>> _kTips = [
  {
    'title': 'La règle 50/30/20',
    'description': 'Allouez 50% aux besoins essentiels, 30% aux envies et 20% à l\'épargne. Simple et efficace pour équilibrer vos finances.',
    'icon': '💡', 'category': 'Budget',
  },
  {
    'title': 'Fonds d\'urgence',
    'description': 'Constituez une réserve de 3 à 6 mois de dépenses. Ce coussin financier vous protège contre les imprévus sans vous endetter.',
    'icon': '🛡️', 'category': 'Épargne',
  },
  {
    'title': 'Automatisez votre épargne',
    'description': 'Programmez un virement automatique dès réception de votre salaire. Épargnez en premier, dépensez le reste.',
    'icon': '🤖', 'category': 'Épargne',
  },
  {
    'title': 'La règle des 24 heures',
    'description': 'Avant tout achat non planifié, attendez 24 heures. Cette pause permet de distinguer un besoin réel d\'une envie passagère.',
    'icon': '⏳', 'category': 'Dépenses',
  },
  {
    'title': 'Suivez vos dépenses quotidiennement',
    'description': 'Notez chaque dépense, même petite. Les petits montants s\'accumulent et peuvent représenter une part importante du budget.',
    'icon': '📊', 'category': 'Budget',
  },
  {
    'title': 'Négociez vos factures',
    'description': 'N\'hésitez pas à négocier vos abonnements, assurances et factures. Une simple demande peut vous faire économiser des milliers de FCFA par an.',
    'icon': '🤝', 'category': 'Économies',
  },
  {
    'title': 'Diversifiez vos revenus',
    'description': 'Cherchez des opportunités de revenus supplémentaires : freelance, vente, location. Ne dépendez pas d\'une seule source.',
    'icon': '💰', 'category': 'Revenus',
  },
  {
    'title': 'Investissez dans votre formation',
    'description': 'Consacrer une partie de votre budget à l\'apprentissage est l\'investissement avec le meilleur retour sur le long terme.',
    'icon': '📚', 'category': 'Investissement',
  },
  {
    'title': 'Comparez avant d\'acheter',
    'description': 'Prenez le temps de comparer les prix. Les applications de comparaison peuvent vous faire économiser considérablement sur vos achats.',
    'icon': '🔍', 'category': 'Dépenses',
  },
  {
    'title': 'Planifiez vos courses',
    'description': 'Faites une liste et respectez-la. Les courses planifiées évitent le gaspillage et réduisent votre budget alimentaire.',
    'icon': '🛒', 'category': 'Budget',
  },
  {
    'title': 'Objectifs financiers SMART',
    'description': 'Définissez des objectifs Spécifiques, Mesurables, Atteignables, Réalistes et Temporels. Un objectif flou mène rarement au succès.',
    'icon': '🎯', 'category': 'Objectifs',
  },
  {
    'title': 'Révisez votre budget mensuellement',
    'description': 'Analysez vos dépenses chaque fin de mois. Identifiez les dépassements et ajustez vos habitudes le mois suivant.',
    'icon': '📅', 'category': 'Budget',
  },
  {
    'title': 'Évitez les dettes à intérêt élevé',
    'description': 'Priorisez le remboursement des dettes avec les taux d\'intérêt les plus élevés. La méthode avalanche vous fait économiser le plus.',
    'icon': '🏦', 'category': 'Dettes',
  },
  {
    'title': 'Cuisinez plutôt que de commander',
    'description': 'Cuisiner à domicile coûte en moyenne 5 fois moins cher que les restaurants ou livraisons. Planifiez vos repas à l\'avance.',
    'icon': '🍳', 'category': 'Économies',
  },
  {
    'title': 'L\'intérêt composé travaille pour vous',
    'description': 'Commencez à épargner tôt. Les intérêts composés doublent votre argent sans effort : 100 000 FCFA à 10%/an = 260 000 FCFA en 10 ans.',
    'icon': '📈', 'category': 'Investissement',
  },
  {
    'title': 'Séparateurs de comptes',
    'description': 'Ouvrez des comptes séparés pour : dépenses courantes, épargne d\'urgence, projets. La séparation mentale aide à ne pas toucher aux réserves.',
    'icon': '🏧', 'category': 'Épargne',
  },
  {
    'title': 'Revoir ses abonnements',
    'description': 'Listez tous vos abonnements et supprimez ceux que vous n\'utilisez pas. Les abonnements oubliés peuvent coûter des milliers de FCFA par mois.',
    'icon': '✂️', 'category': 'Économies',
  },
  {
    'title': 'Évitez les achats émotionnels',
    'description': 'Le stress, la tristesse et même la joie poussent à dépenser de façon irrationnelle. Identifiez vos déclencheurs émotionnels.',
    'icon': '🧠', 'category': 'Dépenses',
  },
  {
    'title': 'Visualisez votre liberté financière',
    'description': 'Définissez à quoi ressemble votre liberté financière. Cette vision claire vous motive à faire les bons choix au quotidien.',
    'icon': '🌟', 'category': 'Objectifs',
  },
  {
    'title': 'Protégez-vous avec des assurances',
    'description': 'Une maladie, un accident ou un sinistre peut anéantir vos économies. Les assurances essentielles sont un investissement, pas une dépense.',
    'icon': '🔒', 'category': 'Épargne',
  },
];

const Map<String, Color> _kTipColors = {
  'Budget': Color(0xFF5B4FFF),
  'Épargne': Color(0xFF00CF8D),
  'Dépenses': Color(0xFFFF8C42),
  'Économies': Color(0xFF00C6AE),
  'Revenus': Color(0xFFFFD60A),
  'Investissement': Color(0xFFAF52DE),
  'Objectifs': Color(0xFFFF3B5C),
  'Dettes': Color(0xFFFF6B6B),
};

// ─── Quiz Data (10 questions chacun) ─────────────────────────────────────────

const List<Map<String, dynamic>> _kQuizData = [
  {
    'topic': 'Budget & Dépenses',
    'icon': '📊',
    'color': 0xFF5B4FFF,
    'questions': [
      {
        'question': 'Selon la règle 50/30/20, quelle part des revenus faut-il consacrer à l\'épargne ?',
        'options': ['10%', '20%', '30%', '50%'],
        'answer': 1,
        'explanation': 'La règle 50/30/20 recommande 20% pour l\'épargne, 50% pour les besoins et 30% pour les envies.',
      },
      {
        'question': 'Qu\'est-ce qu\'un budget équilibré ?',
        'options': ['Dépenses = Revenus', 'Dépenses > Revenus', 'Revenus > Dépenses', 'Aucune dépense'],
        'answer': 2,
        'explanation': 'Un budget équilibré signifie que vos revenus dépassent vos dépenses, permettant d\'épargner.',
      },
      {
        'question': 'Quelle est la première étape pour créer un budget efficace ?',
        'options': ['Réduire les dépenses', 'Lister ses revenus', 'Ouvrir un compte épargne', 'Investir en bourse'],
        'answer': 1,
        'explanation': 'Connaître précisément ses revenus est la base de tout budget solide.',
      },
      {
        'question': 'Comment appelle-t-on les dépenses qui restent fixes chaque mois ?',
        'options': ['Dépenses variables', 'Dépenses fixes', 'Dépenses imprévues', 'Dépenses optionnelles'],
        'answer': 1,
        'explanation': 'Les dépenses fixes (loyer, abonnements) ne varient pas. Les variables (courses, loisirs) fluctuent.',
      },
      {
        'question': 'Quelle stratégie aide à éviter les achats impulsifs ?',
        'options': ['Aller souvent au marché', 'Attendre 24-48h avant d\'acheter', 'Payer en liquide uniquement', 'Éviter les promotions'],
        'answer': 1,
        'explanation': 'La règle des 24-48 heures permet de réfléchir et distinguer besoin et envie passagère.',
      },
      {
        'question': 'Qu\'est-ce que le "lifestyle inflation" ?',
        'options': ['Augmenter ses revenus', 'Augmenter ses dépenses avec ses revenus', 'Réduire son train de vie', 'Investir dans l\'immobilier'],
        'answer': 1,
        'explanation': 'Le lifestyle inflation, c\'est dépenser plus quand on gagne plus, sans augmenter son épargne.',
      },
      {
        'question': 'Quel outil est le plus efficace pour suivre son budget ?',
        'options': ['La mémoire', 'Un tableau Excel ou une app dédiée', 'Les relevés bancaires en fin de mois', 'Les tickets de caisse'],
        'answer': 1,
        'explanation': 'Un outil de suivi en temps réel (app ou tableur) vous donne une vue claire et immédiate.',
      },
      {
        'question': 'Combien de fois par mois est-il recommandé de vérifier son budget ?',
        'options': ['Une fois en fin de mois', 'Jamais, ça stresse', 'Quotidiennement ou hebdomadairement', 'Une fois par an'],
        'answer': 2,
        'explanation': 'Un suivi régulier permet de corriger rapidement les dérapages avant qu\'ils ne s\'accumulent.',
      },
      {
        'question': 'Que signifie "payer ses dettes en boule de neige" ?',
        'options': ['Payer la plus grosse dette en premier', 'Payer la plus petite dette en premier', 'Payer toutes les dettes en même temps', 'Ignorer les dettes'],
        'answer': 1,
        'explanation': 'La méthode boule de neige : on rembourse les petites dettes d\'abord pour créer de l\'élan psychologique.',
      },
      {
        'question': 'Quel est l\'impact d\'un budget écrit sur les finances personnelles ?',
        'options': ['Aucun impact', 'Augmente les dépenses', 'Améliore le contrôle financier', 'Réduit les revenus'],
        'answer': 2,
        'explanation': 'Les études montrent que les personnes qui écrivent leur budget économisent significativement plus.',
      },
    ],
  },
  {
    'topic': 'Épargne & Objectifs',
    'icon': '💰',
    'color': 0xFF00C6AE,
    'questions': [
      {
        'question': 'Combien de mois de dépenses doit représenter un fonds d\'urgence ?',
        'options': ['1 mois', '2 mois', '3 à 6 mois', '12 mois'],
        'answer': 2,
        'explanation': 'Un fonds d\'urgence de 3 à 6 mois protège contre les imprévus sans s\'endetter.',
      },
      {
        'question': 'Quelle est la stratégie d\'épargne la plus efficace ?',
        'options': ['Épargner ce qui reste', 'Épargner avant de dépenser', 'Épargner une fois par an', 'Ne pas épargner si revenus faibles'],
        'answer': 1,
        'explanation': '"Payez-vous en premier" : épargnez dès réception du salaire, dépensez le reste.',
      },
      {
        'question': 'Qu\'est-ce qu\'un objectif SMART en épargne ?',
        'options': ['Vague et flexible', 'Spécifique avec montant et date', 'Très ambitieux', 'Sans contrainte de temps'],
        'answer': 1,
        'explanation': 'SMART = Spécifique, Mesurable, Atteignable, Réaliste, Temporel. Ex: épargner 500 000 FCFA en 12 mois.',
      },
      {
        'question': 'Pourquoi faut-il séparer son épargne de son compte courant ?',
        'options': ['Pour payer plus de frais bancaires', 'Pour éviter de la dépenser impulsivement', 'Pour avoir plus de cartes', 'Aucune raison'],
        'answer': 1,
        'explanation': 'L\'argent "hors de vue" est plus difficile à dépenser. La séparation protège l\'épargne.',
      },
      {
        'question': 'Combien de temps faut-il pour constituer un fonds d\'urgence si on épargne 10% de 500 000 FCFA/mois ?',
        'options': ['1-2 mois', '3-6 mois', '12 mois', '2 ans'],
        'answer': 1,
        'explanation': '10% × 500 000 = 50 000 FCFA/mois. Fonds urgence = 3×500 000 = 1 500 000 / 50 000 = 30 mois... environ 6 mois si on épargne 25%.',
      },
      {
        'question': 'Qu\'est-ce que l\'épargne forcée ?',
        'options': ['Être obligé d\'épargner par la loi', 'Prélèvement automatique vers l\'épargne', 'Mettre de côté uniquement les pièces', 'Prêter de l\'argent'],
        'answer': 1,
        'explanation': 'L\'épargne forcée via virement automatique supprime la tentation de dépenser cet argent.',
      },
      {
        'question': 'Quel est le danger d\'utiliser son fonds d\'urgence pour des vacances ?',
        'options': ['Aucun danger', 'On se retrouve sans filet de sécurité', 'On paie plus d\'impôts', 'La banque est mécontente'],
        'answer': 1,
        'explanation': 'Le fonds d\'urgence est réservé aux vraies urgences. Le vider pour des loisirs vous expose au risque d\'endettement.',
      },
      {
        'question': 'Comment appelle-t-on l\'épargne investie dans des actifs qui génèrent des revenus ?',
        'options': ['Épargne de précaution', 'Épargne productive', 'Épargne dormante', 'Épargne liquide'],
        'answer': 1,
        'explanation': 'L\'épargne productive (actions, immobilier locatif) génère des revenus passifs au fil du temps.',
      },
      {
        'question': 'Quelle visualisation aide le plus à atteindre ses objectifs d\'épargne ?',
        'options': ['Ignorer l\'objectif', 'Une barre de progression visible', 'Penser à autre chose', 'Changer souvent d\'objectif'],
        'answer': 1,
        'explanation': 'Visualiser sa progression active le circuit de récompense du cerveau et maintient la motivation.',
      },
      {
        'question': 'Quel est le bon réflexe quand on reçoit une prime ou un bonus ?',
        'options': ['Tout dépenser pour se faire plaisir', 'Allouer une partie à l\'épargne/objectifs', 'Ignorer cet argent', 'Le garder en liquide'],
        'answer': 1,
        'explanation': 'Les revenus exceptionnels sont une opportunité d\'avancer rapidement sur ses objectifs d\'épargne.',
      },
    ],
  },
  {
    'topic': 'Investissement',
    'icon': '📈',
    'color': 0xFFAF52DE,
    'questions': [
      {
        'question': 'Qu\'est-ce que la diversification en investissement ?',
        'options': ['Tout mettre dans un seul actif', 'Répartir sur différents actifs', 'Investir uniquement en actions', 'Garder en liquide'],
        'answer': 1,
        'explanation': 'Diversifier réduit le risque : si un actif chute, les autres compensent.',
      },
      {
        'question': 'Quel est le principal avantage des intérêts composés ?',
        'options': ['Gains fixes chaque année', 'Croissance exponentielle dans le temps', 'Aucun risque de perte', 'Disponibilité immédiate'],
        'answer': 1,
        'explanation': 'Les intérêts composés génèrent des intérêts sur les intérêts, créant une croissance exponentielle.',
      },
      {
        'question': 'Quelle est la relation entre risque et rendement en investissement ?',
        'options': ['Plus de risque = moins de rendement', 'Aucune relation', 'Plus de risque = potentiellement plus de rendement', 'Moins de risque = plus de rendement'],
        'answer': 2,
        'explanation': 'En finance, risque et rendement potentiel sont liés. Un investissement sûr rapporte peu, un risqué peut rapporter beaucoup ou perdre.',
      },
      {
        'question': 'Qu\'est-ce qu\'un actif financier ?',
        'options': ['Une dépense mensuelle', 'Un bien qui génère de la valeur ou des revenus', 'Une dette', 'Un abonnement'],
        'answer': 1,
        'explanation': 'Un actif (actions, immobilier locatif, obligations) génère de la valeur ou des flux de trésorerie.',
      },
      {
        'question': 'Quel est le bon moment pour commencer à investir ?',
        'options': ['Quand on est riche', 'Le plus tôt possible', 'À la retraite', 'Quand les marchés baissent uniquement'],
        'answer': 1,
        'explanation': 'Commencer tôt maximise l\'effet des intérêts composés. Même de petits montants placés jeune deviennent significatifs.',
      },
      {
        'question': 'Qu\'est-ce qu\'un passif financier ?',
        'options': ['Un bien qui prend de la valeur', 'Une dette ou obligation qui coûte de l\'argent', 'Un compte épargne', 'Un investissement immobilier'],
        'answer': 1,
        'explanation': 'Un passif (prêt auto, crédit conso) vous coûte de l\'argent chaque mois. L\'objectif est de minimiser les passifs.',
      },
      {
        'question': 'Comment appelle-t-on les revenus générés sans travailler activement ?',
        'options': ['Revenus salariaux', 'Revenus passifs', 'Revenus exceptionnels', 'Revenus variables'],
        'answer': 1,
        'explanation': 'Les revenus passifs (loyers, dividendes, royalties) continuent à générer de l\'argent sans effort continu.',
      },
      {
        'question': 'Quelle est la règle du "ne jamais investir" selon les experts ?',
        'options': ['Ne jamais investir en bourse', 'Ne jamais investir l\'argent qu\'on ne peut pas se permettre de perdre', 'Ne jamais investir dans l\'immobilier', 'Ne jamais investir jeune'],
        'answer': 1,
        'explanation': 'Tout investissement comporte un risque. N\'investissez jamais votre fonds d\'urgence ou l\'argent nécessaire à court terme.',
      },
      {
        'question': 'Qu\'est-ce que l\'inflation fait à votre épargne non investie ?',
        'options': ['Elle l\'augmente', 'Elle n\'a aucun effet', 'Elle réduit son pouvoir d\'achat', 'Elle la double'],
        'answer': 2,
        'explanation': 'L\'inflation érode le pouvoir d\'achat : 100 000 FCFA aujourd\'hui vaudront moins dans 10 ans si non investis.',
      },
      {
        'question': 'Qu\'est-ce que le DCA (Dollar Cost Averaging) ?',
        'options': ['Investir tout en une fois', 'Investir régulièrement un montant fixe', 'Vendre quand les marchés baissent', 'Investir uniquement en dollars'],
        'answer': 1,
        'explanation': 'Le DCA consiste à investir un montant fixe régulièrement. Cela lisse le prix d\'achat et réduit l\'impact de la volatilité.',
      },
    ],
  },
  {
    'topic': 'Gestion des dettes',
    'icon': '🏦',
    'color': 0xFFFF6B6B,
    'questions': [
      {
        'question': 'Quelle est la différence entre une "bonne" et une "mauvaise" dette ?',
        'options': ['Il n\'y a pas de différence', 'Bonne = génère un actif, Mauvaise = finance la consommation', 'Bonne = taux bas, Mauvaise = taux élevé', 'Bonne = courte durée'],
        'answer': 1,
        'explanation': 'Une bonne dette finance quelque chose qui prend de la valeur (immobilier). Une mauvaise finance la consommation (crédit conso).',
      },
      {
        'question': 'Quelle méthode de remboursement économise le plus en intérêts ?',
        'options': ['Méthode boule de neige (petites dettes d\'abord)', 'Méthode avalanche (taux élevé d\'abord)', 'Payer le minimum sur toutes', 'Rembourser au hasard'],
        'answer': 1,
        'explanation': 'La méthode avalanche (rembourser les dettes avec le taux le plus élevé en premier) économise le plus en intérêts totaux.',
      },
      {
        'question': 'Qu\'est-ce que le taux d\'endettement recommandé maximum ?',
        'options': ['10% des revenus', '20% des revenus', '33% des revenus', '50% des revenus'],
        'answer': 2,
        'explanation': 'La règle générale : les remboursements de dettes ne doivent pas dépasser 33% de vos revenus nets.',
      },
      {
        'question': 'Que signifie "refinancer" une dette ?',
        'options': ['Augmenter le montant emprunté', 'Remplacer un crédit par un autre à conditions meilleures', 'Annuler sa dette', 'Allonger la durée indéfiniment'],
        'answer': 1,
        'explanation': 'Refinancer permet d\'obtenir un meilleur taux ou de regrouper plusieurs dettes en une seule mensualité réduite.',
      },
      {
        'question': 'Quel impact une dette non remboursée a-t-elle sur votre dossier de crédit ?',
        'options': ['Aucun impact', 'Elle l\'améliore', 'Elle le détériore, rendant les futurs crédits plus difficiles', 'Elle disparaît après 6 mois'],
        'answer': 2,
        'explanation': 'Les impayés dégradent votre historique de crédit, augmentent les taux futurs et peuvent bloquer l\'accès au crédit.',
      },
      {
        'question': 'Pourquoi faut-il éviter de payer uniquement le minimum sur une carte de crédit ?',
        'options': ['Ce n\'est pas un problème', 'Les intérêts s\'accumulent et vous payez beaucoup plus que le prix initial', 'La banque est mécontente', 'Ça réduit votre épargne'],
        'answer': 1,
        'explanation': 'Payer uniquement le minimum signifie rembourser très peu du capital. Les intérêts s\'accumulent et multiplient la dette.',
      },
      {
        'question': 'Quelle est la première action à prendre si on est surendetté ?',
        'options': ['Ignorer la situation', 'Contracter de nouvelles dettes', 'Contacter ses créanciers et négocier', 'Vendre tous ses biens'],
        'answer': 2,
        'explanation': 'Contacter proactivement ses créanciers permet souvent d\'obtenir des moratoires, rééchelonnements ou réductions de taux.',
      },
      {
        'question': 'Qu\'est-ce que le regroupement de crédits ?',
        'options': ['Ouvrir plusieurs comptes', 'Fusionner plusieurs dettes en une seule mensualité', 'Augmenter sa limite de crédit', 'Partager ses dettes avec quelqu\'un'],
        'answer': 1,
        'explanation': 'Le regroupement simplifie la gestion et peut réduire la mensualité totale, mais souvent au prix d\'une durée plus longue.',
      },
      {
        'question': 'Quel type de dette a généralement le taux d\'intérêt le plus élevé ?',
        'options': ['Prêt immobilier', 'Prêt étudiant', 'Crédit à la consommation / découvert bancaire', 'Prêt personnel bancaire'],
        'answer': 2,
        'explanation': 'Les crédits revolving et découverts peuvent atteindre 20-30% d\'intérêts annuels, contre 3-5% pour l\'immobilier.',
      },
      {
        'question': 'Quand vaut-il mieux rembourser une dette plutôt qu\'investir ?',
        'options': ['Jamais, toujours investir', 'Quand le taux de la dette dépasse le rendement potentiel de l\'investissement', 'Toujours rembourser avant d\'investir', 'Ça ne fait aucune différence'],
        'answer': 1,
        'explanation': 'Si votre dette coûte 15% et un investissement rapporte 8%, remboursez la dette d\'abord : vous "gagnez" 15% garanti.',
      },
    ],
  },
  {
    'topic': 'Revenus & Carrière',
    'icon': '💼',
    'color': 0xFFFF9500,
    'questions': [
      {
        'question': 'Qu\'est-ce qu\'un revenu passif ?',
        'options': ['Un salaire mensuel', 'Revenus générés sans travail actif continu', 'Indemnités chômage', 'Prime annuelle'],
        'answer': 1,
        'explanation': 'Les revenus passifs (loyers, dividendes, droits d\'auteur) continuent à arriver même quand vous ne travaillez pas activement.',
      },
      {
        'question': 'Pourquoi est-il risqué d\'avoir une seule source de revenus ?',
        'options': ['Ce n\'est pas risqué', 'La perte de cette source = perte de tous les revenus', 'C\'est plus simple à gérer', 'Les impôts sont plus élevés'],
        'answer': 1,
        'explanation': 'Une seule source de revenus crée une vulnérabilité : chômage, maladie ou fermeture d\'entreprise peut tout effacer.',
      },
      {
        'question': 'Quelle est la meilleure façon d\'augmenter ses revenus à long terme ?',
        'options': ['Travailler plus d\'heures', 'Investir dans ses compétences et sa formation', 'Changer d\'emploi chaque année', 'Demander des heures supplémentaires'],
        'answer': 1,
        'explanation': 'Développer ses compétences augmente sa valeur sur le marché du travail et ouvre des opportunités mieux rémunérées.',
      },
      {
        'question': 'Qu\'est-ce que le salaire net ?',
        'options': ['Salaire avant impôts', 'Salaire après déduction de toutes les charges', 'Salaire avec prime incluse', 'Salaire annuel divisé par 12'],
        'answer': 1,
        'explanation': 'Le salaire net est ce que vous recevez réellement après déduction des impôts et cotisations sociales.',
      },
      {
        'question': 'Quel pourcentage de ses revenus devrait-on consacrer à la formation professionnelle ?',
        'options': ['0%, c\'est l\'employeur qui paie', '1 à 3% de ses revenus', '50% de ses revenus', '10 à 20% uniquement en fin de carrière'],
        'answer': 1,
        'explanation': 'Investir 1 à 3% de ses revenus en formation est une pratique recommandée pour rester compétitif et progresser.',
      },
      {
        'question': 'Comment négocier une augmentation de salaire efficacement ?',
        'options': ['Demander sans se préparer', 'Se comparer au marché et valoriser ses contributions', 'Menacer de partir', 'Demander quand l\'entreprise va mal'],
        'answer': 1,
        'explanation': 'Une bonne négociation salariale s\'appuie sur des données de marché et des résultats concrets que vous avez produits.',
      },
      {
        'question': 'Qu\'est-ce que le freelancing permet principalement ?',
        'options': ['Plus de sécurité d\'emploi', 'Flexibilité et potentiel de revenus variables plus élevés', 'Des avantages sociaux complets', 'Un salaire fixe garanti'],
        'answer': 1,
        'explanation': 'Le freelancing offre flexibilité et potentiel de revenus supérieurs, mais avec moins de sécurité et d\'avantages sociaux.',
      },
      {
        'question': 'Qu\'est-ce qu\'une "side hustle" ?',
        'options': ['Une activité principale', 'Une activité secondaire génératrice de revenus', 'Un hobby non rémunéré', 'Un investissement immobilier'],
        'answer': 1,
        'explanation': 'Une side hustle est une activité secondaire (vente en ligne, consulting, cours) qui génère des revenus complémentaires.',
      },
      {
        'question': 'Pourquoi est-il important de se constituer un réseau professionnel ?',
        'options': ['Uniquement pour trouver un emploi', 'Pour accéder à des opportunités, clients et partenariats', 'Pour avoir des amis', 'Pour les réseaux sociaux'],
        'answer': 1,
        'explanation': '70% des offres d\'emploi ne sont jamais publiées. Le réseau est souvent la meilleure source d\'opportunités professionnelles.',
      },
      {
        'question': 'Quel est l\'effet de l\'inflation sur un salaire fixe non révisé ?',
        'options': ['Aucun effet', 'Augmentation du pouvoir d\'achat', 'Diminution du pouvoir d\'achat', 'Augmentation des impôts'],
        'answer': 2,
        'explanation': 'Si votre salaire ne suit pas l\'inflation, votre pouvoir d\'achat diminue réellement, même si le chiffre reste identique.',
      },
    ],
  },
];

// ─── Glossaire (25 termes) ─────────────────────────────────────────────────────

const List<Map<String, String>> _kGlossary = [
  {'term': 'Budget', 'icon': '📊', 'def': 'Plan financier qui répartit les revenus entre dépenses, épargne et investissements sur une période définie.'},
  {'term': 'Épargne', 'icon': '💰', 'def': 'Partie des revenus mise de côté et non dépensée, destinée à un usage futur ou à des investissements.'},
  {'term': 'Actif', 'icon': '📈', 'def': 'Bien ou ressource qui génère de la valeur ou des revenus (immobilier locatif, actions, obligations, entreprise).'},
  {'term': 'Passif', 'icon': '📉', 'def': 'Dette ou engagement financier qui nécessite des sorties d\'argent régulières (prêt, crédit à la consommation).'},
  {'term': 'Liquidité', 'icon': '💧', 'def': 'Facilité à convertir un actif en argent rapidement et sans perte de valeur significative.'},
  {'term': 'Intérêts composés', 'icon': '🔄', 'def': 'Intérêts calculés sur le capital initial ET sur les intérêts déjà accumulés. Effet "boule de neige" exponentiel.'},
  {'term': 'Diversification', 'icon': '🎯', 'def': 'Stratégie consistant à répartir ses investissements sur différents actifs pour réduire le risque global.'},
  {'term': 'Inflation', 'icon': '📊', 'def': 'Hausse générale des prix qui réduit progressivement le pouvoir d\'achat de la monnaie dans le temps.'},
  {'term': 'Fonds d\'urgence', 'icon': '🛡️', 'def': 'Réserve liquide couvrant 3 à 6 mois de dépenses courantes pour faire face aux imprévus sans s\'endetter.'},
  {'term': 'ROI', 'icon': '📐', 'def': 'Retour Sur Investissement. Mesure le bénéfice réalisé par rapport au coût d\'un investissement, exprimé en %.'},
  {'term': 'Cash flow', 'icon': '💵', 'def': 'Flux de trésorerie : différence entre les entrées (revenus) et sorties (dépenses) d\'argent sur une période.'},
  {'term': 'Patrimoine net', 'icon': '⚖️', 'def': 'Valeur totale de vos actifs moins vos dettes. Indicateur clé de votre santé financière globale.'},
  {'term': 'Taux d\'intérêt', 'icon': '💹', 'def': 'Pourcentage appliqué à un capital emprunté ou investi, représentant le coût ou le gain de l\'argent dans le temps.'},
  {'term': 'Amortissement', 'icon': '📅', 'def': 'Remboursement progressif d\'une dette. Chaque mensualité rembourse une partie du capital et des intérêts.'},
  {'term': 'Portefeuille', 'icon': '💼', 'def': 'Ensemble des investissements (actions, obligations, immobilier) détenus par une personne ou un organisme.'},
  {'term': 'Dividende', 'icon': '🎁', 'def': 'Part des bénéfices d\'une entreprise distribuée à ses actionnaires proportionnellement au nombre d\'actions détenues.'},
  {'term': 'Déflation', 'icon': '📉', 'def': 'Baisse générale des prix. Peut sembler positive mais décourage la consommation et peut provoquer une récession.'},
  {'term': 'Levier financier', 'icon': '🔧', 'def': 'Utilisation de l\'emprunt pour amplifier les gains potentiels. Augmente aussi les pertes potentielles.'},
  {'term': 'Capacité d\'épargne', 'icon': '💪', 'def': 'Montant qu\'il est possible de mettre de côté chaque mois = Revenus nets - Dépenses obligatoires.'},
  {'term': 'Taux d\'endettement', 'icon': '⚠️', 'def': 'Ratio entre les remboursements mensuels de dettes et les revenus nets. Ne devrait pas dépasser 33%.'},
  {'term': 'Revenu passif', 'icon': '🌴', 'def': 'Revenu généré sans effort actif continu : loyers, dividendes, intérêts, royalties sur une création.'},
  {'term': 'Valeur nette', 'icon': '🏆', 'def': 'Même concept que patrimoine net : actifs totaux - passifs totaux = indicateur de richesse réelle.'},
  {'term': 'Rééquilibrage', 'icon': '⚖️', 'def': 'Ajustement périodique d\'un portefeuille d\'investissements pour maintenir la répartition cible entre actifs.'},
  {'term': 'Hedge / Couverture', 'icon': '🛡️', 'def': 'Stratégie pour réduire le risque d\'un investissement en prenant une position inverse sur un actif corrélé.'},
  {'term': 'Solvabilité', 'icon': '✅', 'def': 'Capacité d\'une personne ou entreprise à honorer ses dettes à long terme. Indique la santé financière globale.'},
];

// ─── Onglet Conseils ──────────────────────────────────────────────────────────

class _TipsTab extends StatefulWidget {
  const _TipsTab();

  @override
  State<_TipsTab> createState() => _TipsTabState();
}

class _TipsTabState extends State<_TipsTab> {
  String _filter = 'Tous';

  List<String> get _categories {
    final cats = {'Tous', ..._kTips.map((t) => t['category']!)};
    return cats.toList();
  }

  List<Map<String, String>> get _filtered => _filter == 'Tous'
      ? _kTips
      : _kTips.where((t) => t['category'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        SizedBox(
          height: 42,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final isSelected = cat == _filter;
              final color =
                  _kTipColors[cat] ?? const Color(0xFF5B4FFF);
              return GestureDetector(
                onTap: () => setState(() => _filter = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final tip = _filtered[i];
              final color = _kTipColors[tip['category']] ??
                  const Color(0xFF5B4FFF);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF221E3A) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(tip['icon']!,
                            style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tip['title']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tip['category']!,
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tip['description']!,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Onglet Quiz ───────────────────────────────────────────────────────────────

class _QuizTab extends StatefulWidget {
  const _QuizTab();

  @override
  State<_QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<_QuizTab> {
  int? _selectedTopic;

  @override
  Widget build(BuildContext context) {
    if (_selectedTopic != null) {
      return _QuizGame(
        topic: _kQuizData[_selectedTopic!],
        onFinish: () => setState(() => _selectedTopic = null),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: _kQuizData.length,
      itemBuilder: (_, i) {
        final topic = _kQuizData[i];
        final color = Color(topic['color'] as int);
        final qCount = (topic['questions'] as List).length;

        return GestureDetector(
          onTap: () => setState(() => _selectedTopic = i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(topic['icon'] as String,
                    style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic['topic'] as String,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$qCount questions · ~${(qCount * 0.5).ceil()} min',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuizGame extends StatefulWidget {
  final Map<String, dynamic> topic;
  final VoidCallback onFinish;
  const _QuizGame({required this.topic, required this.onFinish});

  @override
  State<_QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<_QuizGame> {
  int _currentQ = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  List<Map<String, dynamic>> get _questions =>
      List<Map<String, dynamic>>.from(widget.topic['questions'] as List);

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.topic['color'] as int);
    if (_finished) return _buildResult(color);

    final q = _questions[_currentQ];
    final options = List<String>.from(q['options'] as List);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              GestureDetector(
                onTap: widget.onFinish,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.arrow_back_rounded,
                      color: color, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.topic['topic'] as String,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentQ + 1}/${_questions.length}',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentQ + 1) / _questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 20),

          // Score en cours
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C6AE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Score : $_score / ${_currentQ + (_answered ? 1 : 0)}',
                  style: const TextStyle(
                    color: Color(0xFF00C6AE),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Text(
              q['question'] as String,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),

          // Options
          ...List.generate(options.length, (i) {
            final isCorrect = i == (q['answer'] as int);
            Color? optColor;
            if (_answered) {
              optColor = isCorrect
                  ? const Color(0xFF34C759)
                  : (i == _selected ? const Color(0xFFFF3B5C) : null);
            }
            final isDark =
                Theme.of(context).brightness == Brightness.dark;

            return GestureDetector(
              onTap: _answered
                  ? null
                  : () => setState(() {
                        _selected = i;
                        _answered = true;
                        if (isCorrect) _score++;
                      }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: optColor?.withOpacity(0.1) ??
                      (isDark
                          ? const Color(0xFF221E3A)
                          : Colors.white),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: optColor ?? Colors.grey.shade200,
                    width: optColor != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: (optColor ?? color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + i),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: optColor ?? color,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        options[i],
                        style: TextStyle(
                          fontWeight: optColor != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: optColor,
                        ),
                      ),
                    ),
                    if (_answered && isCorrect)
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF34C759), size: 22),
                    if (_answered &&
                        i == _selected &&
                        !isCorrect)
                      const Icon(Icons.cancel_rounded,
                          color: Color(0xFFFF3B5C), size: 22),
                  ],
                ),
              ),
            );
          }),

          if (_answered) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF5B4FFF).withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      q['explanation'] as String,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentQ + 1 < _questions.length) {
                    setState(() {
                      _currentQ++;
                      _selected = null;
                      _answered = false;
                    });
                  } else {
                    setState(() => _finished = true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _currentQ + 1 < _questions.length
                      ? 'Question suivante →'
                      : 'Voir mes résultats',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult(Color color) {
    final total = _questions.length;
    final pct = (_score / total * 100).round();
    final emoji = pct == 100 ? '🏆' : pct >= 80 ? '🌟' : pct >= 60 ? '👍' : '📚';
    final msg = pct == 100
        ? 'Parfait ! Vous maîtrisez ce sujet !'
        : pct >= 80
            ? 'Excellent résultat ! Continuez ainsi.'
            : pct >= 60
                ? 'Bien joué ! Encore un peu d\'entraînement.'
                : 'Continuez à apprendre, vous progressez !';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(
              '$_score / $total',
              style: GoogleFonts.poppins(
                  fontSize: 52, fontWeight: FontWeight.w800, color: color),
            ),
            Text('$pct% de bonnes réponses',
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 16)),
            const SizedBox(height: 12),
            Text(msg,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _currentQ = 0;
                  _selected = null;
                  _answered = false;
                  _score = 0;
                  _finished = false;
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Recommencer',
                    style:
                        GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onFinish,
              child: const Text('← Choisir un autre quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Onglet Glossaire ──────────────────────────────────────────────────────────

class _GlossaryTab extends StatefulWidget {
  const _GlossaryTab();

  @override
  State<_GlossaryTab> createState() => _GlossaryTabState();
}

class _GlossaryTabState extends State<_GlossaryTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _kGlossary
        .where((g) =>
            _query.isEmpty ||
            g['term']!.toLowerCase().contains(_query.toLowerCase()) ||
            g['def']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Rechercher un terme financier...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.menu_book_rounded,
                  size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                '${filtered.length} terme${filtered.length != 1 ? 's' : ''}',
                style:
                    TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final g = filtered[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF221E3A)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(isDark ? 0.15 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B4FFF).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(g['icon']!,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g['term']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: const Color(0xFF5B4FFF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            g['def']!,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
