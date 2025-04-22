import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/time_entry_provider.dart';
import 'provider/project_task_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // j'Initialise les providers et charge les données AVANT de lancer l'app
  // je Crée les instances de provider
  final projectTaskProvider = ProjectTaskProvider();
  final timeEntryProvider = TimeEntryProvider();

  // j'Attend que les providers aient chargé leurs données initiales depuis le stockage


  // C'est simplifié ici. Dans une app complexe, on utiliserait Future.wait
  // ou une logique d'initialisation plus robuste dans les providers eux-mêmes.
  // Les constructeurs des providers lancent déjà _init() qui est async.
  // On pourrait ajouter un `Future<void> isReady` dans chaque provider
  // et attendre ici : await Future.wait([provider1.isReady, provider2.isReady]);
  // Pour ce projet, on suppose que le chargement est assez rapide.

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: projectTaskProvider),
        ChangeNotifierProvider.value(value: timeEntryProvider),
        // Alternative si on n'initialise pas avant :
        // ChangeNotifierProvider(create: (_) => ProjectTaskProvider()),
        // ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Couleur principale comme dans les captures
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
           backgroundColor: Colors.teal[600], // Un peu plus foncé pour l'AppBar
           foregroundColor: Colors.white, // Texte et icônes en blanc dans l'AppBar
        ),
         floatingActionButtonTheme: FloatingActionButtonThemeData(
           backgroundColor: Colors.amber, // Couleur FAB comme spécifié
           foregroundColor: Colors.black, // Couleur icône FAB
         ),
         tabBarTheme: TabBarTheme(
            labelColor: Colors.white, // Texte onglet sélectionné
            unselectedLabelColor: Colors.teal[100], // Texte onglet non sélectionné
            indicator: UnderlineTabIndicator( // Soulignement de l'onglet actif
               borderSide: BorderSide(color: Colors.amber, width: 3.0),
            ),
         ),
         elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
               backgroundColor: Colors.teal[700], // Couleur bouton
               foregroundColor: Colors.white, // Texte bouton
            ),
         ),
         // Définir la couleur de l'ExpansionTile
          listTileTheme: ListTileThemeData(
            iconColor: Colors.teal[800], // Couleur des icônes dans les listes (ex: delete)
          ),
          // Appliquer la couleur primaire aux ExpansionTiles lorsqu'ils sont ouverts
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
             secondary: Colors.amber, // Couleur d'accentuation (utilisée par FAB, indicateur TabBar)
          ),
      ),
      home: HomeScreen(), // L'écran d'accueil
       debugShowCheckedModeBanner: false, // Cache la bannière de debug
    );
  }
}