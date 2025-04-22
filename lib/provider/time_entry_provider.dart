import 'dart:convert'; // Nécessaire pour jsonEncode/Decode
import 'package:collection/collection.dart'; // Pour groupBy
import 'package:flutter/foundation.dart';
// import 'package:localstorage/localstorage.dart'; // <<< SUPPRIMER cette ligne
import 'package:shared_preferences/shared_preferences.dart'; // <<< AJOUTER cette ligne
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  // final LocalStorage _storage = LocalStorage('time_entry_storage.json'); // <<< SUPPRIMER
  // bool _storageReady = false; // <<< SUPPRIMER

  // Clé pour SharedPreferences
  static const String _entriesKey = 'time_entries_v1'; // Clé unique

  List<TimeEntry> _entries = [];

  TimeEntryProvider() {
    _init(); // Initialise le chargement des données
  }

  Future<void> _init() async {
    // Pas besoin de _storage.ready avec SharedPreferences
    await _loadEntries(); // Charger les entrées au démarrage
    // notifyListeners() sera appelé dans _loadEntries si des données sont chargées
  }

  List<TimeEntry> get entries {
    _entries.sort((a, b) => b.date.compareTo(a.date)); // Tri avant de retourner
    return List.unmodifiable(_entries);
  }

  Map<String, List<TimeEntry>> get entriesByProject {
    return groupBy(entries, (TimeEntry entry) => entry.projectId);
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance(); // Obtenir l'instance
    final String? entriesString = prefs.getString(_entriesKey); // Lire la chaîne JSON

    if (entriesString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(entriesString); // Décoder la chaîne
        _entries = decodedList
            .map((item) => TimeEntry.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      } catch (e) {
        print("Error decoding time entries: $e");
        _entries = []; // Réinitialiser si erreur de décodage
        // Optionnel: supprimer la clé invalide
        // await prefs.remove(_entriesKey);
      }
    } else {
      _entries = []; // Initialiser si aucune donnée n'est trouvée
    }
    notifyListeners(); // Notifier après le chargement (même si vide)
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance(); // Obtenir l'instance
    // Encoder la liste en chaîne JSON
    final String encodedData = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString(_entriesKey, encodedData); // Sauvegarder la chaîne
  }

  // Les méthodes add/delete appellent _saveEntries, donc elles utiliseront SharedPreferences
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntries(); // Sauvegarde après ajout
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntries(); // Sauvegarde après suppression
    notifyListeners();
  }
}