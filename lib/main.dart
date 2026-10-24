import 'package:flutter/material.dart';

void main() => runApp(const PrimeProApp());

const primeYellow = Color(0xFFE8FF00);
const primeBlack = Color(0xFF080A0D);
const primeCard = Color(0xFF202329);

class Prediction {
  Prediction({
    required this.match,
    required this.league,
    required this.selection,
    required this.odds,
    required this.vip,
    this.status = 'En attente',
  });

  final String match;
  final String league;
  final String selection;
  final double odds;
  final bool vip;
  String status;
}

class PrimeProApp extends StatelessWidget {
  const PrimeProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prime Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primeBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primeYellow,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primeBlack,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: primeCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: primeCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const PrimeHome(),
    );
  }
}

class PrimeHome extends StatefulWidget {
  const PrimeHome({super.key});

  @override
  State<PrimeHome> createState() => _PrimeHomeState();
}

class _PrimeHomeState extends State<PrimeHome> {
  int tab = 0;
  bool showVip = false;
  bool demoAdmin = false;
  final List<Prediction> predictions = [
    Prediction(
      match: 'Real Madrid vs Barcelona',
      league: 'Liga • Exemple de démonstration',
      selection: 'Plus de 1,5 buts',
      odds: 1.42,
      vip: false,
    ),
    Prediction(
      match: 'Arsenal vs Chelsea',
      league: 'Premier League • Exemple de démonstration',
      selection: 'Les deux équipes marquent',
      odds: 1.75,
      vip: true,
    ),
    Prediction(
      match: 'PSG vs Marseille',
      league: 'Ligue 1 • Exemple de démonstration',
      selection: 'Plus de 2,5 buts',
      odds: 1.88,
      vip: false,
      status: 'Gagné',
    ),
  ];

  void toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      historyPage(),
      profilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primeYellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.sports_soccer, color: primeBlack),
            ),
            const SizedBox(width: 10),
            const Text('PRIME ', style: TextStyle(fontWeight: FontWeight.w900)),
            const Text('PRO', style: TextStyle(color: primeYellow, fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications de démonstration',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Notifications'),
                content: const Text('Aucune nouvelle notification. Le push sera connecté dans la version backend.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
              ),
            ),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: tab == 0 ? pages[0] : tab == 1 ? pages[1] : pages[2],
      bottomNavigationBar: NavigationBar(
        backgroundColor: primeCard,
        indicatorColor: primeYellow.withOpacity(.18),
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: primeYellow), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historique'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }

  Widget homePage() {
    final visible = predictions.where((p) => showVip || !p.vip).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF252A31), Color(0xFF101216)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primeYellow.withOpacity(.45)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VOTRE ESPACE SPORTIF', style: TextStyle(color: primeYellow, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              SizedBox(height: 8),
              Text('Les pronostics du jour', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              SizedBox(height: 6),
              Text('Des analyses à consulter avec discernement. Aucun résultat n’est garanti.', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: modeButton('FREE', false)),
            const SizedBox(width: 10),
            Expanded(child: modeButton('VIP', true)),
          ],
        ),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Aucun pronostic dans cette catégorie.')))
        else
          ...visible.map(predictionCard),
        const SizedBox(height: 12),
        if (demoAdmin)
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: primeYellow, foregroundColor: primeBlack),
            onPressed: addPredictionDialog,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un pronostic (démo admin)'),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => setState(() => demoAdmin = !demoAdmin),
          icon: Icon(demoAdmin ? Icons.lock_open : Icons.admin_panel_settings),
          label: Text(demoAdmin ? 'Quitter le mode admin démo' : 'Ouvrir les outils admin (démo)'),
        ),
        if (!demoAdmin)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Mode admin de démonstration uniquement : aucune authentification réelle.', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
      ],
    );
  }

  Widget modeButton(String label, bool vip) {
    final selected = showVip == vip;
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: selected ? primeYellow : primeCard,
        foregroundColor: selected ? primeBlack : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: () => setState(() => showVip = vip),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }

  Widget predictionCard(Prediction p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(p.league, style: const TextStyle(color: Colors.white60, fontSize: 12))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: p.vip ? Colors.amber.withOpacity(.18) : Colors.white10, borderRadius: BorderRadius.circular(20)),
                child: Text(p.vip ? 'VIP' : 'FREE', style: TextStyle(color: p.vip ? primeYellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ]),
            const SizedBox(height: 10),
            Text(p.match, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.ads_click, color: primeYellow),
              const SizedBox(width: 8),
              Expanded(child: Text(p.selection)),
              Text(p.odds.toStringAsFixed(2), style: const TextStyle(color: primeYellow, fontSize: 18, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Text('Statut : ', style: TextStyle(color: Colors.white60)),
              Text(p.status, style: TextStyle(color: p.status == 'Gagné' ? Colors.greenAccent : Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (demoAdmin)
                PopupMenuButton<String>(
                  onSelected: (value) => setState(() => p.status = value),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'En attente', child: Text('En attente')),
                    PopupMenuItem(value: 'Gagné', child: Text('Gagné')),
                    PopupMenuItem(value: 'Perdu', child: Text('Perdu')),
                    PopupMenuItem(value: 'Annulé', child: Text('Annulé')),
                  ],
                  child: const Icon(Icons.edit, size: 19),
                ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget historyPage() {
    final finished = predictions.where((p) => p.status != 'En attente').toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Historique', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('Pronostics dont le résultat a été renseigné.', style: TextStyle(color: Colors.white60)),
        const SizedBox(height: 16),
        if (finished.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('Aucun résultat enregistré pour le moment.')))
        else
          ...finished.map(predictionCard),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Mon profil', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        const CircleAvatar(radius: 38, backgroundColor: primeYellow, child: Icon(Icons.person, color: primeBlack, size: 40)),
        const SizedBox(height: 12),
        const Center(child: Text('Invité Prime Pro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const Center(child: Text('Compte de démonstration', style: TextStyle(color: Colors.white60))),
        const SizedBox(height: 20),
        const Card(child: ListTile(leading: Icon(Icons.workspace_premium, color: primeYellow), title: Text('Abonnement Premium'), subtitle: Text('Les paiements seront ajoutés dans une prochaine version.'))),
        const Card(child: ListTile(leading: Icon(Icons.shield_outlined), title: Text('Confidentialité et sécurité'), subtitle: Text('Le prototype ne collecte pas de données personnelles.'))),
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: Text('Les pronostics sportifs comportent un risque. Les cotes et résultats doivent être vérifiés auprès de sources fiables.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      ],
    );
  }

  Future<void> addPredictionDialog() async {
    final match = TextEditingController();
    final league = TextEditingController(text: 'Football');
    final selection = TextEditingController();
    final odds = TextEditingController(text: '1.50');
    bool vip = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouveau pronostic'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: match, decoration: const InputDecoration(labelText: 'Match')),
              const SizedBox(height: 10),
              TextField(controller: league, decoration: const InputDecoration(labelText: 'Compétition')),
              const SizedBox(height: 10),
              TextField(controller: selection, decoration: const InputDecoration(labelText: 'Sélection')),
              const SizedBox(height: 10),
              TextField(controller: odds, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Cote indicative')),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Réservé VIP'),
                value: vip,
                onChanged: (value) => setDialogState(() => vip = value),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Annuler')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: primeYellow, foregroundColor: primeBlack),
              onPressed: () {
                final parsedOdds = double.tryParse(odds.text.replaceAll(',', '.'));
                if (match.text.trim().isEmpty || selection.text.trim().isEmpty || parsedOdds == null || parsedOdds <= 1) {
                  toast('Vérifie le match, la sélection et la cote supérieure à 1.');
                  return;
                }
                setState(() {
                  predictions.insert(0, Prediction(
                    match: match.text.trim(),
                    league: league.text.trim(),
                    selection: selection.text.trim(),
                    odds: parsedOdds,
                    vip: vip,
                  ));
                });
                Navigator.pop(dialogContext);
                toast('Pronostic ajouté en mémoire (démo).');
              },
              child: const Text('Publier'),
            ),
          ],
        ),
      ),
    );
  }
}
