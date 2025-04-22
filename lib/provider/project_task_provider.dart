import 'dart:convert'; // Nécessaire pour jsonEncode/Decode
import 'package:flutter/foundation.dart';
// import 'package:localstorage/localstorage.dart'; // <<< SUPPRIMER cette ligne
import 'package:shared_preferences/shared_preferences.dart'; // <<< AJOUTER cette ligne
import '../models/project.dart';
import '../models/task.dart';

class ProjectTaskProvider with ChangeNotifier {

  // final storage = LocalStorage('project_task_storage.json'); // <<< SUPPRIMER (attention: nom différent ici 'storage' vs '_storage')
  // bool _storageReady = false; // <<< SUPPRIMER

  // Clés pour SharedPreferences
  static const String _projectsKey = 'projects_v1'; // Clé unique
  static const String _tasksKey = 'tasks_v1';     // Clé unique

  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => List.unmodifiable(_projects);
  List<Task> get tasks => List.unmodifiable(_tasks);

  ProjectTaskProvider() {
    _init(); // Initialise le chargement
  }

  Future<void> _init() async {
    // Pas besoin de _storage.ready avec SharedPreferences
    final prefs = await SharedPreferences.getInstance(); // Obtenir l'instance une fois
    await _loadProjects(prefs); // Passer l'instance pour éviter de la recréer
    await _loadTasks(prefs);    // Passer l'instance

    if (_projects.isEmpty && _tasks.isEmpty) {
      _addInitialData(); // Toujours ajouter les données initiales si nécessaire
    }
    // notifyListeners sera appelé par _loadProjects et _loadTasks séparément
    // ou on pourrait le mettre ici une seule fois si on chargeait tout avant de notifier.
  }

  void _addInitialData() {
    // Cette logique reste la même, mais elle appellera addProject/addTask
    // qui appelleront _saveProjects/_saveTasks qui utilisent SharedPreferences
    if (_projects.isEmpty) {
      addProject(Project(id: 'proj_alpha', name: 'Project Alpha'));
      addProject(Project(id: 'proj_gamma', name: 'Project Gamma'));
    }
    if (_tasks.isEmpty) {
      addTask(Task(id: 'task_a', name: 'Task A'));
      addTask(Task(id: 'task_b', name: 'Task B'));
      addTask(Task(id: 'task_c', name: 'Task C'));
      addTask(Task(id: 'task_1', name: 'Task 1'));
      addTask(Task(id: 'task_2', name: 'Task 2'));
    }
  }

  Future<void> _loadProjects(SharedPreferences prefs) async { // Accepte l'instance prefs
    final String? projectsString = prefs.getString(_projectsKey); // Lire la chaîne JSON

    if (projectsString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(projectsString); // Décoder
        _projects = decodedList
            .map((item) => Project.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      } catch (e) {
        print("Error decoding projects: $e");
        _projects = []; // Réinitialiser si erreur
        // await prefs.remove(_projectsKey); // Optionnel
      }
    } else {
      _projects = []; // Initialiser si vide
    }
    notifyListeners(); // Notifier après chargement des projets
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance(); // Obtenir l'instance
    // Encoder en JSON
    final String encodedData = jsonEncode(_projects.map((p) => p.toJson()).toList());
    await prefs.setString(_projectsKey, encodedData); // Sauvegarder la chaîne
  }

  Future<void> _loadTasks(SharedPreferences prefs) async { // Accepte l'instance prefs
    final String? tasksString = prefs.getString(_tasksKey); // Lire la chaîne JSON

    if (tasksString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(tasksString); // Décoder
        _tasks = decodedList
            .map((item) => Task.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      } catch (e) {
        print("Error decoding tasks: $e");
        _tasks = []; // Réinitialiser si erreur
        // await prefs.remove(_tasksKey); // Optionnel
      }
    } else {
      _tasks = []; // Initialiser si vide
    }
    notifyListeners(); // Notifier après chargement des tâches
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance(); // Obtenir l'instance
    // Encoder en JSON
    final String encodedData = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, encodedData); // Sauvegarder la chaîne
  }

  // Les méthodes add/delete restent identiques, elles appellent les _saveXxx correspondants
  void addProject(Project project) {
    _projects.add(project);
    _saveProjects();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    _saveProjects();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  // Les helpers restent identiques
  String getProjectNameById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id).name;
    } catch (e) {
      return 'Unknown Project';
    }
  }

  String getTaskNameById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id).name;
    } catch (e) {
      return 'Unknown Task';
    }
  }
}